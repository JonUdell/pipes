CREATE OR REPLACE FUNCTION suppress_and_count_repeats(
    schema_name TEXT,                -- Schema name of the target table
    table_name TEXT,                 -- Name of the target table
    partition_by_column TEXT,        -- Column to partition by
    order_by_columns TEXT,           -- Columns to order by
    additional_column_names TEXT[]   -- Array of additional column names
) RETURNS SETOF JSON AS $$
DECLARE
    generated_query TEXT;            -- Variable to store the generated SQL query
    additional_selects TEXT;         -- Variable to store the dynamically constructed additional select statements
    additional_json_build TEXT;      -- Variable to store the dynamically constructed JSON build statements
    i INT;                           -- Loop counter
BEGIN
    -- Initialize additional selects and JSON build strings
    additional_selects := '';
    additional_json_build := '';
    
    -- Loop through the array of additional column names to construct the select statements and JSON build
    FOR i IN 1 .. array_length(additional_column_names, 1) LOOP
        IF i > 1 THEN
            additional_selects := additional_selects || ', ';  -- Add comma separator for multiple columns
            additional_json_build := additional_json_build || ', ';
        END IF;
        additional_selects := additional_selects || format('%I', trim(additional_column_names[i]));  -- Format the select statement for each additional column
        additional_json_build := additional_json_build || format('''%I'', %I', trim(additional_column_names[i]), trim(additional_column_names[i]));  -- Doubling single quotes to correctly format a single quote within the string.
    END LOOP;

    -- Construct the dynamic SQL query
    generated_query := format(
        $q$
        WITH cte AS (
            SELECT
                %I AS partition_column,                         -- Alias the partition by column
                %s,                                             -- Include additional columns in the result
                COUNT(*) OVER (PARTITION BY %I)::INTEGER AS partition_count,  -- Compute partition count
                ROW_NUMBER() OVER (PARTITION BY %I ORDER BY %s)::INTEGER AS row_num  -- Compute row number within each partition
            FROM
                %I.%I                                           -- Target schema and table
        )
        SELECT json_build_object(
            'display_partition_column', CASE 
                                            WHEN row_num = 1 THEN partition_column || ' (' || partition_count || ')'
                                            ELSE ''
                                        END,
            'additional_columns', json_build_array(%s),        -- Construct JSON array for additional columns
            'row_num', row_num,
            'partition_count', partition_count
        ) AS result
        FROM
            cte
        ORDER BY
            partition_column,
            row_num;
        $q$,
        partition_by_column, additional_selects, partition_by_column, partition_by_column, order_by_columns,
        schema_name, table_name, additional_selects
    );

    --RAISE exception 'Generated Query: %', generated_query;
    
    -- Execute the generated query and return the result as JSON
    RETURN QUERY EXECUTE generated_query;
END;
$$ LANGUAGE plpgsql;

-- $q$ for nesting within $$
-- %I for Postgres table and column names
-- %s for strings


