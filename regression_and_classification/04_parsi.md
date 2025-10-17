Parsimoniousness
================

Simple explanations are considered better than complicated ones. Part of the 
reason for that is that complex explanations can be totally uninformative: 
we may summarize a data set with the data set itself, for example, and doing
so gives us nothing.

This has practical implications.

I've had to implement a linear regression right into an sql query:

``` sql
WITH t AS (SELECT * FROM your_table)
SELECT
  t.*,
  (
    7.149e+01
    + 7.486e-02 * num_of_doors
    - 3.206e-01 * wheel_base
    - 2.154e-02 * length
    + 3.442e-01 * width
    + 3.066e-02 * height
    - 8.554e-03 * curb_weight
    - 1.831e+00 * num_of_cylinders
    - 2.311e-03 * engine_size
    - 1.659e+00 * bore
    - 6.712e-02 * stroke
    + 1.461e+00 * compression_ratio
    - 9.034e-03 * horsepower
    - 3.220e-03 * peak_rpm
    + 2.655e-04 * price
    + 2.302e+00 * make_audi
    + 3.912e+00 * make_bmw
    + 1.032e+01 * make_chevrolet
    + 6.203e+00 * make_dodge
    + 1.972e+00 * make_honda
    + 1.267e+00 * make_isuzu
    + 7.941e+00 * make_jaguar
    + 3.672e+00 * make_mazda
    + 4.149e+00 * "make_mercedes-benz"
    + 5.813e+00 * make_mercury
    + 6.102e+00 * make_mitsubishi
    + 5.237e+00 * make_nissan
    + 4.031e+00 * make_peugot
    + 6.608e+00 * make_plymouth
    + 3.247e-01 * make_porsche
    -- make_renault: NA coefficient -> excluded
    + 2.907e+00 * make_saab
    + 1.555e+00 * make_subaru
    + 4.980e+00 * make_toyota
    + 4.441e+00 * make_volkswagen
    + 6.438e+00 * make_volvo
    - 1.260e+01 * fuel_type_diesel
    - 2.519e+00 * aspiration_turbo
    + 2.531e+00 * body_style_hatchback
    + 2.970e+00 * body_style_sedan
    + 3.262e+00 * body_style_wagon
    + 1.289e+00 * body_style_hardtop
    + 4.622e-01 * drive_wheels_fwd
    - 1.322e+00 * drive_wheels_4wd
    - 8.917e-02 * engine_location_rear
    + 1.354e-01 * engine_type_ohcv
    - 1.149e+00 * engine_type_ohc
    + 1.707e+00 * engine_type_l
    -- engine_type_rotor/ohcf/dohcv: NA coefficients -> excluded
    + 3.418e-01 * fuel_system_2bbl
    - 1.344e+00 * fuel_system_mfi
    + 4.681e+00 * fuel_system_1bbl
    + 2.622e+00 * fuel_system_spfi
    -- fuel_system_4bbl/idi: NA coefficients -> excluded
    - 2.868e-01 * fuel_system_spdi
  ) AS predicted_mpg
FROM t;

```

This is obviously onerous in its complexity. It would be nice if we could 
somehow automatically restrict our regressions to just the most important
variables. Maybe we even want to accept some decrease in accuracy or interpretability in exchange for 
simplicity.

This is the question of feature selection, which we will discuss later. For now
let's learn how we can use this framework of regression to ::05_classify:classify rather than regress::.