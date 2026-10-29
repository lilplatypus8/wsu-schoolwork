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
#define LDR_DO_PIN GPIO_NUM_23
void app_main(void)
{
    gpio_config_t out_cfg = {
        .pin_bit_mask = (1ULL << LED_PIN),
        .mode = GPIO_MODE_OUTPUT,
    };
    gpio_config(&out_cfg);
    gpio_config_t in_cfg = {
        .pin_bit_mask = (1ULL << LDR_DO_PIN),
        .mode = GPIO_MODE_INPUT,
    };
    gpio_config(&in_cfg);
    while (1)
    {
        int do_level = gpio_get_level(LDR_DO_PIN);
        printf("DO = %d\n", do_level);
        if (do_level == 1)
        {                               /* adjust after testing */
            gpio_set_level(LED_PIN, 1); /* LED on */
        }
        else
        {
            gpio_set_level(LED_PIN, 0); /* LED off */
        }
        vTaskDelay(pdMS_TO_TICKS(200));
    }
}
