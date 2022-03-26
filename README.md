
<!-- README.md is generated from README.Rmd. Please edit that file -->

The goal of gsovn is to scrape dataset from
\[gso.gov.vn\[(<https://gso.gov.vn>) (Vietnam General statistic
organization)

## Installation

You can install the development version of gsovn from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("vohai611/gsovn")
```

# TODO

1.  Add option to download csv

2.  use `{{crul}}` to send asynch request in the case download multiple
    dataset

## Example

You can check what dataset is now on gso.gov.vn

``` r
library(gsovn)
df = gso_avail()
head(df)
#> # A tibble: 6 × 3
#>   title                                                        link  title_clean
#>   <chr>                                                        <chr> <chr>      
#> 1 Số đơn vị hành chính có đến phân theo địa phương             http… So don vi …
#> 2 Hiện trạng sử dụng đất phân theo địa phương (Tính đến 31/12… http… Hien trang…
#> 3 Cơ cấu đất sử dụng phân theo địa phương (Tính đến 31/12/201… http… Co cau dat…
#> 4 Tổng số giờ nắng tại một số trạm quan trắc                   http… Tong so gi…
#> 5 Tổng số giờ nắng tại một số trạm quan trắc                   http… Tong so gi…
#> 6 Số giờ nắng các tháng trong năm tại một số trạm quan trắc    http… So gio nan…
```

To get the data set you want, use `gso_read(url)`.

``` r
df$link[2] |> gso_read()
#> $title
#> [1] "Hiện trạng sử dụng đất phân theo địa phương (Tính đến 31/12/2018)(*) chia theo Phân theo địa phương và Hiện trạng sử dụng đất"
#> 
#> $data
#> # A tibble: 71 × 6
#>    ``        `Tổng diện tích` `Đất sản xuất …` `Đất lâm nghiệp` `Đất chuyên dù…`
#>    <chr>     <chr>            <chr>            <chr>            <chr>           
#>  1 CẢ NƯỚC   33.123,6         11.498,5         14.940,8         1.893,2         
#>  2 Đồng bằn… 2.125,9          789,8            494,4            324,3           
#>  3 Hà Nội    335,9            154,3            22,2             64,1            
#>  4 Vĩnh Phúc 123,6            55,9             32,0             17,6            
#>  5 Bắc Ninh  82,3             42,5             0,6              17,7            
#>  6 Quảng Ni… 617,8            60,8             373,7            45,5            
#>  7 Hải Dương 166,8            85,7             9,3              31,5            
#>  8 Hải Phòng 156,2            50,5             19,2             29,3            
#>  9 Hưng Yên  93,0             53,6             ..               17,7            
#> 10 Thái Bình 158,6            92,9             0,9              30,1            
#> # … with 61 more rows, and 1 more variable: `Đất ở` <chr>
```

This function call `rvest::html_table()` to parse html to tibble,
therefore the result might be slow. I will add the option to download
csv file in the future
