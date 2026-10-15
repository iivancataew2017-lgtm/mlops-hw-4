{% macro amount_bucket(column) -%}
case
    when {{ column }} >= {{ var('large_amount_threshold') }} then 'LARGE'
    when {{ column }} >= {{ var('medium_amount_threshold') }} then 'MEDIUM'
    else 'SMALL'
end
{%- endmacro %}
