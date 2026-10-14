idf_component_register(SRCS "main2.c" "main3.c" "main.c"
                       INCLUDE_DIRS "."
                       REQUIRES driver esp_driver_gpio esp_adc spi_flash)
