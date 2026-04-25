import 'package:flutter/material.dart';

class ToolItem {
  final String name;
  final String description;
  final String url;
  final IconData icon;

  const ToolItem({
    required this.name,
    required this.description,
    required this.url,
    required this.icon,
  });
}

const List<ToolItem> raspberryTipsTools = [
  ToolItem(
    name: 'GPIO Pinout',
    description: 'Pin-Belegung aller Raspberry Pi Modelle',
    url: 'https://raspberry.tips/raspberry-pi-gpio-pinout',
    icon: Icons.developer_board,
  ),
  ToolItem(
    name: 'WPA Supplicant Generator',
    description: 'WLAN-Konfiguration für den Raspberry Pi erstellen',
    url: 'https://raspberry.tips/wpa-supplicant-generator',
    icon: Icons.wifi_password,
  ),
  ToolItem(
    name: 'Docker Compose Generator',
    description: 'Docker Compose Konfigurationen erstellen',
    url: 'https://raspberry.tips/raspberry-pi-docker-compose-generator',
    icon: Icons.layers,
  ),
  ToolItem(
    name: 'Elektronik-Rechner',
    description: 'LED-Widerstände, Spannungsteiler & Farbcodes',
    url: 'https://raspberry.tips/elektronik-rechner',
    icon: Icons.calculate,
  ),
  ToolItem(
    name: 'SD-Karten Rechner',
    description: 'Lebensdauer deiner SD-Karte berechnen',
    url:
        'https://raspberry.tips/sd-karten-lebensdauer-rechner-wie-lange-haelt-dein-speicher',
    icon: Icons.sd_card,
  ),
  ToolItem(
    name: 'Netzteil-Kalkulator',
    description: 'Watt-Bedarf deines Projekts ermitteln',
    url:
        'https://raspberry.tips/raspberry-pi-netzteil-kalkulator-wie-viel-watt-braucht-mein-projekt',
    icon: Icons.power,
  ),
  ToolItem(
    name: 'Kaufberater 2026',
    description: 'Welches Raspberry Pi Modell passt zu dir?',
    url:
        'https://raspberry.tips/raspberry-pi-kaufberater-2026-welches-modell-passt-zu-meinem-projekt',
    icon: Icons.shopping_cart,
  ),
  ToolItem(
    name: 'Subnet-Rechner',
    description: 'IP-Adressen und Netzwerke berechnen',
    url: 'https://raspberry.tips/subnet-rechner',
    icon: Icons.lan,
  ),
];
