/*
 * SPDX-FileCopyrightText: 2010-2022 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: CC0-1.0
 */

#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"
#include "esp_adc/adc_oneshot.h"
#define LED_PIN GPIO_NUM_19
#define ADC_CHANNEL ADC_CHANNEL_6 /* GPIO34 */
#define POT_THRESHOLD 2000
void app_main(void)
{
    gpio_config_t out_cfg = {
        .pin_bit_mask = (1ULL << LED_PIN),
        .mode = GPIO_MODE_OUTPUT,
    };
    gpio_config(&out_cfg);
    adc_oneshot_unit_handle_t adc1_handle;
    adc_oneshot_unit_init_cfg_t init_config1 = {.unit_id = ADC_UNIT_1};
    adc_oneshot_new_unit(&init_config1, &adc1_handle);
    adc_oneshot_chan_cfg_t chan_config = {
        .bitwidth = ADC_BITWIDTH_DEFAULT, /* 12-bit: 0 to 4095 */
        .atten = ADC_ATTEN_DB_12,         /* full 0 to 3.3 V range */
    };
    adc_oneshot_config_channel(adc1_handle, ADC_CHANNEL, &chan_config);
    while (1)
    {
        int adc_val = 0;
        adc_oneshot_read(adc1_handle, ADC_CHANNEL, &adc_val);
        printf("adc = %d\n", adc_val);
        if (adc_val > POT_THRESHOLD)
        {
            gpio_set_level(LED_PIN, 1);
        }
        else
        {
            gpio_set_level(LED_PIN, 0);
        }
        vTaskDelay(pdMS_TO_TICKS(100));
    }
}
