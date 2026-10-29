/*
 * SPDX-FileCopyrightText: 2010-2022 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: CC0-1.0
 */

#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"
#define LED_PIN GPIO_NUM_19
void app_main(void)
{
    gpio_config_t out_cfg = {
        .pin_bit_mask = (1ULL << LED_PIN),
        .mode = GPIO_MODE_OUTPUT,
    };
    gpio_config(&out_cfg);
    while (1)
    {
        gpio_set_level(LED_PIN, 1); /* LED on */
        printf("LED ON\n");
        vTaskDelay(pdMS_TO_TICKS(500));
        gpio_set_level(LED_PIN, 0); /* LED off */
        printf("LED OFF\n");
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}
