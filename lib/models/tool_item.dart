import 'package:flutter/material.dart';

class ToolItem {
  final String name;
  final String description;
  final String url;
  final IconData icon;
  final String? nameEn;
  final String? descriptionEn;
  final String? urlEn;

  const ToolItem({
    required this.name,
    required this.description,
    required this.url,
    required this.icon,
    this.nameEn,
    this.descriptionEn,
    this.urlEn,
  });
}

const List<ToolItem> raspberryTipsTools = [
  ToolItem(
    name: 'GPIO Pinout',
    description: 'Pin-Belegung aller Raspberry Pi Modelle',
    descriptionEn: 'Pin layout for all Raspberry Pi models',
    url: 'https://raspberry.tips/raspberry-pi-gpio-pinout',
    urlEn: 'https://raspberry.tips/en/raspberry-pi-gpio-pinout',
    icon: Icons.developer_board,
  ),
  ToolItem(
    name: 'WPA Supplicant Generator',
    description: 'WLAN-Konfiguration für den Raspberry Pi erstellen',
    descriptionEn: 'Create Wi-Fi configuration for your Raspberry Pi',
    url: 'https://raspberry.tips/wpa-supplicant-generator',
    urlEn: 'https://raspberry.tips/en/wpa-supplicant-generator-en',
    icon: Icons.wifi_password,
  ),
  ToolItem(
    name: 'Docker Compose Generator',
    description: 'Docker Compose Konfigurationen erstellen',
    descriptionEn: 'Generate Docker Compose configurations',
    url: 'https://raspberry.tips/raspberry-pi-docker-compose-generator',
    urlEn: 'https://raspberry.tips/en/raspberry-pi-docker-compose-generator',
    icon: Icons.layers,
  ),
  ToolItem(
    name: 'Elektronik-Rechner',
    nameEn: 'Electronics Calculator',
    description: 'LED-Widerstände, Spannungsteiler & Farbcodes',
    descriptionEn: 'LED resistors, voltage dividers & color codes',
    url: 'https://raspberry.tips/elektronik-rechner',
    urlEn: 'https://raspberry.tips/en/electronics-calculator',
    icon: Icons.calculate,
  ),
  ToolItem(
    name: 'SD-Karten Rechner',
    nameEn: 'SD Card Calculator',
    description: 'Lebensdauer deiner SD-Karte berechnen',
    descriptionEn: 'Calculate the lifespan of your SD card',
    url:
        'https://raspberry.tips/sd-karten-lebensdauer-rechner-wie-lange-haelt-dein-speicher',
    urlEn: 'https://raspberry.tips/en/calculate-raspberry-pi-sd-card-lifespan-test-now',
    icon: Icons.sd_card,
  ),
  ToolItem(
    name: 'Netzteil-Kalkulator',
    nameEn: 'Power Supply Calculator',
    description: 'Watt-Bedarf deines Projekts ermitteln',
    descriptionEn: 'Estimate the wattage needed for your project',
    url:
        'https://raspberry.tips/raspberry-pi-netzteil-kalkulator-wie-viel-watt-braucht-mein-projekt',
    urlEn: 'https://raspberry.tips/en/raspberrypi-tutorials/raspberry-pi-power-supply-calculator-how-many-watts-does-my-project-need',
    icon: Icons.power,
  ),
  ToolItem(
    name: 'Kaufberater 2026',
    nameEn: 'Buying Guide 2026',
    description: 'Welches Raspberry Pi Modell passt zu dir?',
    descriptionEn: 'Which Raspberry Pi model suits your project?',
    url:
        'https://raspberry.tips/raspberry-pi-kaufberater-2026-welches-modell-passt-zu-meinem-projekt',
    urlEn: 'https://raspberry.tips/en/raspberry-pi-buying-guide',
    icon: Icons.shopping_cart,
  ),
];
