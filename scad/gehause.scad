// Parametrisches Gehaeuse mit aufgestecktem Deckel

$fn = 48;

gehaeuse_breite = 85;
gehaeuse_tiefe = 80;
gehaeuse_hoehe = 41;

wandstaerke = 2;
bodenstaerke = 2;

deckel_dicke = 3;
deckel_lippe_hoehe = 5;
deckel_lippe_wand = 1.5;
deckel_spiel = 0.3;

platine_lochabstand_x = 63;
platine_lochabstand_y = 40;
platine_abstand_lange_kante = 6;
platine_offset_x = 0;
platine_offset_y = 0;
platine_dicke = 1.5;

schraubdom_hoehe = 6;
schraubdom_durchmesser = 6;
schraubloch_durchmesser = 2.6;

aussparung_a = 10;
aussparung_b = 38;
antennen_spalt = 4;
antennen_blende_abstand_deckeloberflaeche = 16;
aussparung_z_unten =
    gehaeuse_hoehe
    - antennen_blende_abstand_deckeloberflaeche
    - antennen_spalt;

deckel_blende_dicke = 3;
deckel_blende_ueberdeckung = 3;
deckel_aussenkante_hoehe = 6;
deckel_aussenkante_radius = 2.5;
deckel_aussenkante_unten_radius = 1;
deckel_text = "pico2_drv8871";
deckel_text_groesse = 7;
deckel_text_tiefe = 0.6;
kabel_freiraum_durchmesser = 5;

usb_ausschnitt_breite = 12;
usb_ausschnitt_hoehe = 8;
usb_ausschnitt_radius = 1.5;
usb_abstand_dom_y = 8;
usb_abstand_dom_z = 15;
usb_blende_ueberdeckung = 4;

platinen_spalt_breite = 7;
platinen_spalt_abstand_schraubdom = 3;
platinen_spalt_b = platine_abstand_lange_kante + platine_lochabstand_y - platinen_spalt_abstand_schraubdom;
platinen_spalt_a = platinen_spalt_b - platinen_spalt_breite;

oberer_kabel_spalt_durchmesser = 4;
oberer_kabel_spalt_abstand_schraubdom = 33;
oberer_kabel_spalt_z_abstand_schraubdom = 10;
oberer_kabel_spalt_mitte_x =
    gehaeuse_breite / 2
    + platine_offset_x
    - platine_lochabstand_x / 2
    + oberer_kabel_spalt_abstand_schraubdom;

unterteil_hoehe = gehaeuse_hoehe - deckel_dicke;
platine_unterkante_z = bodenstaerke + schraubdom_hoehe;
platine_oberkante_z = platine_unterkante_z + platine_dicke;
unterer_linker_dom_y = platine_abstand_lange_kante + platine_offset_y;
usb_ausschnitt_mitte_y = unterer_linker_dom_y + usb_abstand_dom_y;
usb_ausschnitt_mitte_z = platine_unterkante_z + usb_abstand_dom_z;
platinen_spalt_z_unten = platine_oberkante_z;
oberer_kabel_spalt_z_unten = platine_unterkante_z + oberer_kabel_spalt_z_abstand_schraubdom;
rechter_blenden_start_z =
    gehaeuse_hoehe
    - antennen_blende_abstand_deckeloberflaeche;
linker_blenden_start_z = platinen_spalt_z_unten;
oberer_blenden_start_z = oberer_kabel_spalt_z_unten;
deckel_preview_z = max(
    deckel_lippe_hoehe,
    unterteil_hoehe - min(
        rechter_blenden_start_z,
        linker_blenden_start_z,
        oberer_blenden_start_z,
        usb_ausschnitt_mitte_z - usb_ausschnitt_hoehe / 2 - usb_blende_ueberdeckung
    )
);

innen_breite = gehaeuse_breite - 2 * wandstaerke;
innen_tiefe = gehaeuse_tiefe - 2 * wandstaerke;

module gehaeuse_schale() {
    innen_hoehe = unterteil_hoehe - bodenstaerke;

    difference() {
        cube([gehaeuse_breite, gehaeuse_tiefe, unterteil_hoehe]);

        translate([wandstaerke, wandstaerke, bodenstaerke])
            cube([innen_breite, innen_tiefe, innen_hoehe + 0.1]);

        rechte_seiten_aussparung();
        linker_platinen_spalt();
        oberer_kabel_spalt();
        linker_usb_ausschnitt();
    }
}

module rechte_seiten_aussparung() {
    translate([
        gehaeuse_breite - wandstaerke - 0.1,
        aussparung_a,
        aussparung_z_unten
    ])
        cube([
            wandstaerke + 0.2,
            aussparung_b - aussparung_a,
            unterteil_hoehe - aussparung_z_unten + 0.1
        ]);
}

module linker_platinen_spalt() {
    spalt_breite = platinen_spalt_b - platinen_spalt_a;
    spalt_radius = spalt_breite / 2;
    spalt_mitte_y = platinen_spalt_a + spalt_radius;
    spalt_mitte_z = platinen_spalt_z_unten + spalt_radius;

    union() {
        translate([
            -0.1,
            platinen_spalt_a,
            spalt_mitte_z
        ])
            cube([
                wandstaerke + 0.2,
                spalt_breite,
                unterteil_hoehe - spalt_mitte_z + 0.1
            ]);

        translate([-0.1, spalt_mitte_y, spalt_mitte_z])
            rotate([0, 90, 0])
                cylinder(r = spalt_radius, h = wandstaerke + 0.2);
    }
}

module oberer_kabel_spalt() {
    spalt_radius = oberer_kabel_spalt_durchmesser / 2;
    spalt_mitte_z = oberer_kabel_spalt_z_unten + spalt_radius;

    union() {
        translate([
            oberer_kabel_spalt_mitte_x - spalt_radius,
            gehaeuse_tiefe - wandstaerke - 0.1,
            spalt_mitte_z
        ])
            cube([
                oberer_kabel_spalt_durchmesser,
                wandstaerke + 0.2,
                unterteil_hoehe - spalt_mitte_z + 0.1
            ]);

        translate([
            oberer_kabel_spalt_mitte_x,
            gehaeuse_tiefe - wandstaerke - 0.1,
            spalt_mitte_z
        ])
            rotate([-90, 0, 0])
                cylinder(r = spalt_radius, h = wandstaerke + 0.2);
    }
}

module linker_usb_ausschnitt() {
    translate([
        -0.1,
        usb_ausschnitt_mitte_y,
        usb_ausschnitt_mitte_z
    ])
        rotate([0, 90, 0])
            linear_extrude(height = wandstaerke + 0.2)
                // Nach der Rotation liegt der erste Wert in Z, der zweite in Y.
                gerundetes_rechteck_zentriert_2d(
                    usb_ausschnitt_hoehe,
                    usb_ausschnitt_breite,
                    usb_ausschnitt_radius
                );
}

module schraubdom() {
    difference() {
        cylinder(d = schraubdom_durchmesser, h = schraubdom_hoehe);

        translate([0, 0, -0.05])
            cylinder(d = schraubloch_durchmesser, h = schraubdom_hoehe + 0.1);
    }
}

module platinenhalter() {
    for (x = [-platine_lochabstand_x / 2, platine_lochabstand_x / 2])
        for (y = [0, platine_lochabstand_y])
            translate([
                gehaeuse_breite / 2 + platine_offset_x + x,
                platine_abstand_lange_kante + platine_offset_y + y,
                bodenstaerke
            ])
                schraubdom();
}

module gehaeuse_unterteil() {
    union() {
        gehaeuse_schale();
        platinenhalter();
    }
}

module deckel_lippe() {
    lippe_breite = innen_breite - 2 * deckel_spiel;
    lippe_tiefe = innen_tiefe - 2 * deckel_spiel;
    lippe_hoehe = deckel_lippe_hoehe + 0.1;

    difference() {
        cube([lippe_breite, lippe_tiefe, lippe_hoehe]);

        translate([deckel_lippe_wand, deckel_lippe_wand, -0.05])
            cube([
                lippe_breite - 2 * deckel_lippe_wand,
                lippe_tiefe - 2 * deckel_lippe_wand,
                lippe_hoehe + 0.1
            ]);
    }
}

module deckel_platte() {
    difference() {
        translate([
            -deckel_blende_dicke,
            -deckel_blende_dicke,
            0
        ])
            linear_extrude(height = deckel_dicke)
                gerundetes_rechteck_2d(
                    gehaeuse_breite + 2 * deckel_blende_dicke,
                    gehaeuse_tiefe + 2 * deckel_blende_dicke,
                    deckel_aussenkante_radius
                );

        deckel_gravur();
    }
}

module deckel_gravur() {
    translate([
        gehaeuse_breite / 2,
        gehaeuse_tiefe / 2,
        deckel_dicke - deckel_text_tiefe
    ])
        linear_extrude(height = deckel_text_tiefe + 0.1)
            text(
                deckel_text,
                size = deckel_text_groesse,
                halign = "center",
                valign = "center"
            );
}

module gerundetes_rechteck_zentriert_2d(breite, hoehe, radius) {
    translate([-breite / 2, -hoehe / 2])
        gerundetes_rechteck_2d(breite, hoehe, radius);
}

module gerundetes_rechteck_2d(breite, tiefe, radius) {
    translate([radius, radius])
        offset(r = radius)
            square([breite - 2 * radius, tiefe - 2 * radius]);
}

module deckel_aussenkante() {
    radius = deckel_aussenkante_unten_radius;

    difference() {
        deckel_aussenkante_roh();

        translate([
            -deckel_blende_dicke - 0.1,
            -deckel_blende_dicke - 0.1,
            -deckel_aussenkante_hoehe - 0.1
        ])
            linear_extrude(height = radius + 0.1)
                difference() {
                    offset(delta = 0.1)
                        gerundetes_rechteck_2d(
                            gehaeuse_breite + 2 * deckel_blende_dicke,
                            gehaeuse_tiefe + 2 * deckel_blende_dicke,
                            deckel_aussenkante_radius
                        );

                    offset(delta = -radius)
                        gerundetes_rechteck_2d(
                            gehaeuse_breite + 2 * deckel_blende_dicke,
                            gehaeuse_tiefe + 2 * deckel_blende_dicke,
                            deckel_aussenkante_radius
                        );
                }
    }
}

module deckel_aussenkante_roh() {
    translate([
        -deckel_blende_dicke,
        -deckel_blende_dicke,
        -deckel_aussenkante_hoehe
    ])
        linear_extrude(height = deckel_aussenkante_hoehe + 0.1)
            difference() {
                gerundetes_rechteck_2d(
                    gehaeuse_breite + 2 * deckel_blende_dicke,
                    gehaeuse_tiefe + 2 * deckel_blende_dicke,
                    deckel_aussenkante_radius
                );

                translate([deckel_blende_dicke, deckel_blende_dicke])
                    square([gehaeuse_breite, gehaeuse_tiefe]);
            }
}

module deckel_aussparungsblende() {
    blende_y = aussparung_b - aussparung_a + 2 * deckel_blende_ueberdeckung;
    blende_z_unten = rechter_blenden_start_z;
    blende_hoehe = gehaeuse_hoehe - blende_z_unten;

    translate([
        gehaeuse_breite,
        aussparung_a - deckel_blende_ueberdeckung,
        blende_z_unten - unterteil_hoehe
    ])
        cube([deckel_blende_dicke, blende_y, blende_hoehe]);
}

module deckel_linke_seitenblende() {
    linker_blende_y_start = platinen_spalt_a - deckel_blende_ueberdeckung;
    linker_blende_y_end = platinen_spalt_b + deckel_blende_ueberdeckung;

    usb_blende_y = usb_ausschnitt_breite + 2 * usb_blende_ueberdeckung;
    usb_blende_z_abdeckung = usb_ausschnitt_hoehe + 2 * usb_blende_ueberdeckung;
    usb_blende_y_start = usb_ausschnitt_mitte_y - usb_blende_y / 2;
    usb_blende_y_end = usb_ausschnitt_mitte_y + usb_blende_y / 2;
    usb_blende_z_unten = usb_ausschnitt_mitte_z - usb_blende_z_abdeckung / 2;

    blende_y_start = min(linker_blende_y_start, usb_blende_y_start);
    blende_y_end = max(linker_blende_y_end, usb_blende_y_end);
    blende_z_unten = min(linker_blenden_start_z, usb_blende_z_unten);
    blende_z_start = blende_z_unten - unterteil_hoehe;
    blende_z = -blende_z_start + 0.1;
    kabel_radius = kabel_freiraum_durchmesser / 2;
    kabel_mitte_y = (platinen_spalt_a + platinen_spalt_b) / 2;
    kabel_z_start = linker_blenden_start_z - unterteil_hoehe;

    difference() {
        translate([
            -deckel_blende_dicke,
            blende_y_start,
            blende_z_start
        ])
            cube([
                deckel_blende_dicke,
                blende_y_end - blende_y_start,
                blende_z
            ]);

        deckel_kabel_freiraum(kabel_mitte_y, kabel_z_start, kabel_radius);
    }
}

module deckel_oberer_kabel_blende() {
    blende_x = oberer_kabel_spalt_durchmesser + 2 * deckel_blende_ueberdeckung;
    blende_z_unten = oberer_blenden_start_z;
    blende_hoehe = gehaeuse_hoehe - blende_z_unten;
    blende_x_start = oberer_kabel_spalt_mitte_x - blende_x / 2;
    blende_z_start = blende_z_unten - unterteil_hoehe;
    kabel_radius = oberer_kabel_spalt_durchmesser / 2;

    difference() {
        translate([
            blende_x_start,
            gehaeuse_tiefe,
            blende_z_start
        ])
            cube([blende_x, deckel_blende_dicke, blende_hoehe]);

        deckel_oberer_kabel_freiraum(
            oberer_kabel_spalt_mitte_x,
            blende_z_start,
            kabel_radius
        );
    }
}

module deckel_oberer_kabel_freiraum(mitte_x, unten_z, radius) {
    translate([
        mitte_x - radius,
        gehaeuse_tiefe - 0.1,
        unten_z - 0.1
    ])
        cube([2 * radius, deckel_blende_dicke + 0.2, radius + 0.1]);

    translate([
        mitte_x,
        gehaeuse_tiefe - 0.1,
        unten_z + radius
    ])
        rotate([-90, 0, 0])
            cylinder(r = radius, h = deckel_blende_dicke + 0.2);
}

module deckel_kabel_freiraum(mitte_y, unten_z, radius) {
    translate([
        -deckel_blende_dicke - 0.1,
        mitte_y - radius,
        unten_z - 0.1
    ])
        cube([deckel_blende_dicke + 0.2, 2 * radius, radius + 0.1]);

    translate([
        -deckel_blende_dicke - 0.1,
        mitte_y,
        unten_z + radius
    ])
        rotate([0, 90, 0])
            cylinder(r = radius, h = deckel_blende_dicke + 0.2);
}

module deckel() {
    lippe_breite = innen_breite - 2 * deckel_spiel;
    lippe_tiefe = innen_tiefe - 2 * deckel_spiel;

    deckel_platte();

    deckel_aussenkante();

    translate([
        (gehaeuse_breite - lippe_breite) / 2,
        (gehaeuse_tiefe - lippe_tiefe) / 2,
        -deckel_lippe_hoehe
    ])
        deckel_lippe();

    deckel_aussparungsblende();
    deckel_linke_seitenblende();
    deckel_oberer_kabel_blende();
}

gehaeuse_unterteil();

translate([
    gehaeuse_breite + 15,
    0,
    deckel_preview_z
])
    deckel();
