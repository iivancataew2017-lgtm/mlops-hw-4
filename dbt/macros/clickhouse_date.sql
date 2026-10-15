{% macro clickhouse__day_of_week(date, isoweek=true) -%}
toDayOfWeek({{ date }}){% if not isoweek %} % 7 + 1{% endif %}
{%- endmacro %}
