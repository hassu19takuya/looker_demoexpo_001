view: ndt {
# If necessary, uncomment the line below to include explore_source.
# include: "husky_demo.model.lkml"

    derived_table: {
      explore_source: retail_analytics {
        column: total_order_num { field: order_items.total_order_num }
        column: uu { field: order_items.uu }
        column: total_sale_price { field: order_items.total_sale_price }
        column: created_month { field: order_items.created_month }
        filters: {
          field: order_items.created_date
          value: "3 years"
        }
      }
    }
    dimension: total_order_num {
      label: "オーダー情報 オーダー数"
      type: number
    }
    dimension: uu {
      label: "オーダー情報 購入者数"
      type: number
    }
    dimension: total_sale_price {
      label: "オーダー情報 総売上額"
      value_format: "$#,##0"
      type: number
    }
    dimension: created_month {
      label: "オーダー情報 受注日 Month"
      type: date_month
    }
  }
