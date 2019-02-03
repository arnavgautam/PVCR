R_CNFL = Tariff("CNFL",
                "Residential",
                [(0:200, 63.13), (200:300, 96.87), (300:1000, 100.14)],
                [(0:100, 0.0)],
                0.06,
                21.03,
                3.51,
                0.01,
                [0.992832136 0.999770704 1.00427654 0.983489891 1.009385917 1.012387984 0.979508228 0.994153679 0.97686098 1.015651323 1.015252586 1.016430032]);


CI_CNFL = Tariff("CNFL",
                "Commercial - Industrial",
                [(0:3000, 106.68), (3001:10000, 64.22)],
                [(0:8,  80426.32), (8:1000,  10053.29 )],
                0.06,
                21.03,
                3.51,
                0.01,
                [0.997759211, 1.029462815, 0.970880339, 1.004265761, 1.070739906, 1.039263159, 0.993586335, 1.002523373, 0.983852239, 0.950187922, 0.990476922, 0.967002018]);


TMT_CNFL = Tariff("CNFL",
                "Medium Voltage",
                [("punta", 54.42), ("valle", 27.21), ("noche", 19.59)],
                [("punta",  9542.79), ("valle",  6790.00), ("noche",  4310.42)],
                0.06,
                21.03,
                3.51,
                0.01,
                [1.024524936, 0.949492666, 1.025369474, 1.061316875, 1.023024878, 0.996315038, 0.992322444, 0.986442682, 0.947434961, 1.016134986, 1.006473428, 0.971147632]);

R_ICE = Tariff("ICE",
                "Residential",
                [(0:40.99,  3189.60), (41:200.99,  79.74), (201:1000, 143.71)],
                [(0:100, 0.0)],
                0.06,
                21.03,
                4.50,
                0.01,
                [0.992832136 0.999770704 1.00427654 0.983489891 1.009385917 1.012387984 0.979508228 0.994153679 0.97686098 1.015651323 1.015252586 1.016430032]);


CI_ICE = Tariff("ICE",
                "Commercial - Industrial",
                [(0:3000, 120.10), (3001:10000,  71.86)],
                [(0:1000,  11878.17)],
                0.06,
                21.03,
                4.50,
                0.01,
                [0.997759211, 1.029462815, 0.970880339, 1.004265761, 1.070739906, 1.039263159, 0.993586335, 1.002523373, 0.983852239, 0.950187922, 0.990476922, 0.967002018]);


TMT_ICE = Tariff("ICE",
                "Medium Voltage",
                [("punta",  68.90), ("valle",  25.60), ("noche",  15.76)],
                [("punta",  11181.25), ("valle",  7806.89), ("noche",  5000.50)],
                0.06,
                21.03,
                4.50, 
                0.01,
                [1.024524936, 0.949492666, 1.025369474, 1.061316875, 1.023024878, 0.996315038, 0.992322444, 0.986442682, 0.947434961, 1.016134986, 1.006473428, 0.971147632]);