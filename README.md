# KeySeeBee (modified from [TeXitoi/keyseebee](https://github.com/TeXitoi/keyseebee))

![KeySeeBee](images/keyseebee.jpg)

KeySeeBee is a split ergo keyboard. It is only 2 PCB (so the name)
with (almost) only SMD components on it. It's no longer only a keyboard,
it now has keys, USB, rotary encoders, and OLEDs.

The old firmware at [Keyberon](https://github.com/TeXitoi/keyberon), a
pure rust firmware, has not been ported yet as I wanted more of the functionality
that QMK provides without having to code some of those advanced features.

QMK firmware for this version is located [here](https://github.com/sefodopo/qmk_firmware/tree/keyseebee).

## Features

 * 44 keys, using Cherry MX or Kailh choc switches, only 1U keycaps.
 * USB-C connector on the 2 sides.
 * TRRS cable for connecting the 2 halves (for power and UART communication between the 2 halves).
 * 2 STM32F072 MCU, with hardware USB DFU bootloader and crystal less USB;
 * Only onboard SMD components (except for the switches, TRRS
   connector, and optional components).
 * 2 SPI OLED 128x32 3.3V (optional not SMD)
 * 2 EC11 Rotary Encoder (optional not SMD)
 * [Plate files](cad/) (optional).

## Inspiration

 * [Plaid](https://github.com/hsgw/plaid) for "show the components"
 * [GergoPlex](https://www.gboards.ca/product/gergoplex) for "just a keyboard" and "only a PCB with SMD components"
 * [Lily58](https://github.com/kata0510/Lily58) for the thumb cluster
 * [Kyria](https://blog.splitkb.com/blog/introducing-the-kyria) for
   "don't be affraid of pinky stagger"
 * [keyseebee](https://github.com/TeXitoi/keyberon) for initial design without the OLEDs and Encoders and way too many diodes :)

## Gallery

### v0.1, build by TeXitoi

![From above with one side upside down](images/above-with-back.jpg)

![Side view](images/side-view.jpg)

### v0.1, build by TeXitoi, Gateron silent clear (MX footprint), 3D printed plate

![From above](images/mx-and-plate.jpg)

### v0.2, build by eropleco, with 1.2mm anodized aluminium plate

![Left](images/eropleco-left.jpg)

![Right](images/eropleco-right.jpg)

### v0.3, build by TeXitoi, Gateron silent clear, 3D printed fat plate

![Side view](images/fat-plate.jpg)

### v0.4, build by Sefodopo, Coming Sometime?

## Bill Of Materials

Price is for 5 keyboards including shipping.

|Item                                                                      |Package|Qty|Remarks                                |Price |
|--------------------------------------------------------------------------|-------|--:|---------------------------------------|-----:|
|[Left PCB](pcb/gerbers/)                                                  |       |  1|Ordered at [JLCPCB](https://jlcpcb.com)|      |
|[Right PCB](pcb/gerbers/)                                                 |       |  1|Ordered at [JLCPCB](https://jlcpcb.com)|33.14€|
|[USB-C connector](https://www.aliexpress.com/item/33004501788.html)       |16 pins|  2|                                       | 1.44€|
|[PJ320A TRRS connector](https://www.aliexpress.com/item/4000661212458.html)|      |  2|                                       | 1.01€|
|[STM32F072CBT6 MCU](https://www.aliexpress.com/item/1005002841528809.html)|LQFP-48|  2|STM32F072C8T6 would also work          | 9.65€|
|[XC6206P332MR regulator](https://www.aliexpress.com/item/33015891307.html)|SOT-23 |  2|Price is for 50                        | 1.93€|
|[SMD switch](https://www.aliexpress.com/item/4000546059630.html)          | 3×6mm |  4|Price is for 100                       | 1.35€|
|[5.1kΩ resistor](https://www.aliexpress.com/item/32865947306.html)        | 0805  |  6|Price is for 100                       |      |
|[1µF capacitor](https://www.aliexpress.com/item/32964553793.html)         | 0805  |  4|Price is for 100                       |      |
|[100nF capacitor](https://www.aliexpress.com/item/32964553793.html)       | 0805  | 10|Price is for 100                       | 3.46€|
|[Bumpers](https://www.aliexpress.com/item/32289191938.html)               | 5×2mm | 10|Price is for 100                       | 1.75€|
|[Cherry MX compatible](https://www.aliexpress.com/item/32836368723.html) or [Kailh Choc](https://www.aliexpress.com/item/1005005883472162.html) switch|5 pins (PCB mount)|44| | |
|1U keycap compatible with the chosen switches                             |       | 44|                                       |      |
|[TRRS cable](https://www.aliexpress.com/item/1005003677396291.html)       |Jack 3.5mm| 1|4 contacts needed                    |      |
|[USB-C cable](https://www.aliexpress.com/item/1005002811739151.html)      |       |  1|USB-2 is enough                        |      |

About 60€ without switches, keycaps and cables for 5 keyboards
(12€/keyboard).

## Compiling and flashing

Follow the QMK guides using my branch of qmk_firmware (or copy my code, idk)... I might add more specific steps in the future.
## What's the layout

Yeah, I'm still figuring it out. I really prefer ZMK and if I can get ZMK working on this keyboard, I'll start using that instead
and update the layout here for what I like.
