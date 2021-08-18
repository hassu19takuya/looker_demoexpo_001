view: asahi_layout_field_pick {
  derived_table: {
    sql:
    WITH all_join_base AS (
        SELECT
            *
        FROM
        (
          select
            chain_store_code
            , store_code
            , jan_code
            , transaction_date
            , chain_sales
            , last_year_chain_sales
          from
            `looker.table_org_demo_dataset_pos_with_last_year_parted_clustered`
        ) as p
        LEFT OUTER JOIN
        (
          select *
          from `looker.pos_goods_master_teikyo_distinct_parted_clustered`
          where CHAIN_CD = "00000000"
        )  as pos_goods_master
        ON
            p.jan_code = pos_goods_master.JAN
        LEFT OUTER JOIN
        (
          select *
          from `looker.org_pos_store_master`
        ) as s
        ON
            p.chain_store_code = s.CHAIN_CD
            and p.store_code = s.CHAIN_TENPO_CD
        LEFT OUTER JOIN
        (
          select *
          from
            `looker.pos_calendar_master_date_parted_clustered`
        ) as c
        ON
            p.chain_store_code = c.CHAIN_CD
            and p.transaction_date = c.D_YMD
    )
    {% assign count = 0 %}
    {% assign union_count = 0 %}
      -- FOR文で,KPIの数だけ縦持ち用のUNION処理を行う
      {% assign kpi_nm = _filters['asahi_layout_field_pick.f_kpi'] | sql_quote %}
    {% assign kpi_nm_spilit = kpi_nm | spilit:',' %}
    {% for word in kpi_nm_spilit %}

        -- UNIONを付けるかどうかを制御
        {% if union_count == 0 %}
          -- ベースのテーブルなのでUNION付けない
          {% assign union_count = union_count | plus: 1 %}
        {% elsif union_count > 0 %}
          UNION ALL
        {% endif %}

        SELECT
      # マスタのどのカラムを使って集計するか制御
        {% if asahi_layout_field_pick.pattern_1_bunrui_nm2._is_selected %}
          {% if count > 0 %} , {% endif %}
          PATTERN_1_BUNRUI_NM2
          {% assign count = count | plus: 1 %}
        {% endif %}
        {% if asahi_layout_field_pick.pattern_1_bunrui_nm3._is_selected %}
          {% if count > 0 %} , {% endif %}
          PATTERN_1_BUNRUI_NM3
          {% assign count = count | plus: 1 %}
        {% endif %}
        {% if asahi_layout_field_pick.maker1_nm._is_selected %}
          {% if count > 0 %} , {% endif %}
          MAKER1_NM
          {% assign count = count | plus: 1 %}
        {% endif %}
        , {{ word }} as KPI_NM
        , SUM(chain_sales) as KPI_VAL
        FROM `all_join_base`
      # 選択された切り口の数に合わせて集計
        group by
        {% if count == 1 %}
          1,2
        {% elsif count == 2 %}
          1,2,3
        {% elsif count == 3 %}
          1,2,3,4
        {% else %}
          1
        {% endif %}
    {% endfor %}
      ;;
  }
  filter: f_kpi {
    label: "KPI選択"
    suggestions: [
      "売上金額"
      , "売上金額_前年"
      , "売上金額_前年差異"
      , "売上金額_前年比"
    ]
  }

  dimension: pattern_1_bunrui_nm2 {
    type: string
    sql: ${TABLE}.PATTERN_1_BUNRUI_NM2 ;;
    label: "カテゴリ"
  }
  dimension: pattern_1_bunrui_nm3 {
    type: string
    sql: ${TABLE}.PATTERN_1_BUNRUI_NM3 ;;
    label: "サブカテ"
  }
  dimension: maker1_nm {
    type: string
    sql: ${TABLE}.MAKER1_NM ;;
    label: "メーカー"
  }

  dimension: kpi {
    type: string
    sql: ${TABLE}.KPI_NM ;;
  }
  measure: value {
    type: sum
    sql: ${TABLE}.KPI_VAL ;;
  }
}
