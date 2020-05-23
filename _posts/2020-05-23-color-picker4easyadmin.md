---
title:  "Color picker for EasyAdmin - simple"
date:   2020-05-23
categories: DEV
tags: php symfony easyadmin
---

How to create simple and fast color picker for EasyAdmin.  
No bundle no configuration just simple class and js library.

* download the color picker [jqColorPicker.min.js](https://www.cdnpkg.com/tinyColorPicker/file/jqColorPicker.min.js/){:target="_blank"}
* create ColorPickerType class

    {% gist 6212b19bf961ef07000164064e6041a8 %}

* Configure your field in EasyAdmin entity definition

    ```
    - { property: 'color', label: 'Color', type: 'App\Form\ColorPickerType' }
    ```

* Overwrite you NEW & EDIT templates if required (example for edit)

    {% gist c76297da2d09399bceb1571357f192b4 %}

* For LIST & SHOW use template

    {% gist 7140789c640a9c19440e46f54c08a6b8 %}

* and add template to you property

    ```
    - { property: 'rentChartColor', label: 'Color', sortable: false, template: 'admin/fields/color.html.twig' }
    ```

* Result

    <img src="/data/2020-05-23/color-picker.png"/>
