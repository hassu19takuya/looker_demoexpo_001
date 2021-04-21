view: products {
  sql_table_name: "PUBLIC"."PRODUCTS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
    hidden: yes
  }

  dimension: brand {
    label: "ブランド名"
    type: string
    sql: TRIM(${TABLE}.brand) ;;

    link: {
      label: "Website"
      url: "http://www.google.com/search?q={{ value | encode_uri }}+clothes&btnI"
      icon_url: "http://www.google.com/s2/favicons?domain=www.{{ value | encode_uri }}.com"
    }

    link: {
      label: "Facebook"
      url: "http://www.google.com/search?q=site:facebook.com+{{ value | encode_uri }}+clothes&btnI"
      icon_url: "https://static.xx.fbcdn.net/rsrc.php/yl/r/H3nktOa7ZMg.ico"
    }

    link: {
      label: "{% if value == 'Volcom' %}{{value}}{% else %} {{ order_items.created_date }}{% endif %} Analytics Dashboard"
      url:
            "{% if value == 'Volcom' %}/dashboards/thelook_japanese::brand_analytics_dashboard?ブランド={{ value | encode_uri }}&期間={{ order_items.created_date | encode_uri }}{% endif %}"
      icon_url: "http://www.looker.com/favicon.ico"
    }

    drill_fields: [category, name]

  }

  dimension: category {
    type: string
    sql: ${TABLE}."CATEGORY" ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}."COST" ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}."DEPARTMENT" ;;
  }

  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."DISTRIBUTION_CENTER_ID" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}."RETAIL_PRICE" ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}."SKU" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.name, distribution_centers.id, inventory_items.count]
  }
}
