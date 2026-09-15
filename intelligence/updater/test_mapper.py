from mapper import map_market_records


sample = [

    {

        "Commodity":"Cotton",

        "Market":"Pune",

        "District":"Pune",

        "State":"Maharashtra",

        "Min_Price":"7000",

        "Max_Price":"7500",

        "Modal_Price":"7200",

        "Arrival_Date":"15/09/2026",

        "Variety":"Cotton",

        "Grade":"A"

    }

]


result = map_market_records(sample)


print(result)