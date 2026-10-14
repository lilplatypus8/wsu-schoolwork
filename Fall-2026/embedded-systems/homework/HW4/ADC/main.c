#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"
#include "esp_adc/adc_oneshot.h"
#define LED_PIN GPIO_NUM_32
#define BTN_PIN GPIO_NUM_19
#define ADC_CHANNEL ADC_CHANNEL_6
#define LDR_THRESHOLD 1000
void app_main(void)
{
  gpio_config_t out_cfg = {
    .pin_bit_mask = (1ULL << LED_PIN),
    .mode = GPIO_MODE_OUTPUT,
  };
  gpio_config(&out_cfg);

  gpio_config_t in_cfg = {
      .pin_bit_mask = (1ULL << BTN_PIN),
      .mode = GPIO_MODE_INPUT,
      .pull_up_en = GPIO_PULLUP_ENABLE,
  };
  gpio_config(&in_cfg);

  adc_oneshot_unit_handle_t adc1_handle;
  adc_oneshot_unit_init_cfg_t init_config1 = { .unit_id = ADC_UNIT_1 };
  adc_oneshot_new_unit(&init_config1, &adc1_handle);

  adc_oneshot_chan_cfg_t chan_config = {
    .bitwidth = ADC_BITWIDTH_DEFAULT, /* 12-bit: 0 to 4095 */
    .atten = ADC_ATTEN_DB_12,
  };
  adc_oneshot_config_channel(adc1_handle, ADC_CHANNEL, &chan_config);

  while (1) {
    int adc_val = 0;
    adc_oneshot_read(adc1_handle, ADC_CHANNEL, &adc_val);
    printf("adc = %d\n", adc_val);
    if (adc_val > LDR_THRESHOLD && gpio_get_level(BTN_PIN) == 0) { /* dark: LDR covered */
      gpio_set_level(LED_PIN, 0);
    } else if (adc_val > LDR_THRESHOLD || gpio_get_level(BTN_PIN) == 0) {
      gpio_set_level(LED_PIN, 1);
    } else {
      gpio_set_level(LED_PIN, 0);
    }
  }
}