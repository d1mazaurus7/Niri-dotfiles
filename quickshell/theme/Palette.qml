    pragma Singleton
    import QtQuick
    QtObject {
        readonly property color background: "#13140d"
        readonly property color error: "#ffb4ab"
        readonly property color error_container: "#93000a"
        readonly property color inverse_on_surface: "#303129"
        readonly property color inverse_primary: "#576421"
        readonly property color inverse_surface: "#e4e3d7"
        readonly property color on_background: "#e4e3d7"
        readonly property color on_error: "#690005"
        readonly property color on_error_container: "#ffdad6"
        readonly property color on_primary: "#2b3400"
        readonly property color on_primary_container: "#dbea98"
        readonly property color on_primary_fixed: "#181e00"
        readonly property color on_primary_fixed_variant: "#404c0a"
        readonly property color on_secondary: "#2e331b"
        readonly property color on_secondary_container: "#e1e6c3"
        readonly property color on_secondary_fixed: "#191d08"
        readonly property color on_secondary_fixed_variant: "#444930"
        readonly property color on_surface: "#e4e3d7"
        readonly property color on_surface_variant: "#c7c8b8"
        readonly property color on_tertiary: "#04372f"
        readonly property color on_tertiary_container: "#bdece0"
        readonly property color on_tertiary_fixed: "#00201b"
        readonly property color on_tertiary_fixed_variant: "#214e45"
        readonly property color outline: "#919283"
        readonly property color outline_variant: "#46483c"
        readonly property color primary: "#bfce7f"
        readonly property color primary_container: "#404c0a"
        readonly property color primary_fixed: "#dbea98"
        readonly property color primary_fixed_dim: "#bfce7f"
        readonly property color secondary: "#c5caa8"
        readonly property color secondary_container: "#444930"
        readonly property color secondary_fixed: "#e1e6c3"
        readonly property color secondary_fixed_dim: "#c5caa8"
        readonly property color surface: "#13140d"
        readonly property color surface_bright: "#393a31"
        readonly property color surface_container: "#1f2019"
        readonly property color surface_container_high: "#2a2b23"
        readonly property color surface_container_highest: "#34352d"
        readonly property color surface_container_low: "#1b1c15"
        readonly property color surface_container_lowest: "#0e0f08"
        readonly property color surface_dim: "#13140d"
        readonly property color surface_tint: "#bfce7f"
        readonly property color surface_variant: "#46483c"
        readonly property color tertiary: "#a1d0c4"
        readonly property color tertiary_container: "#214e45"
        readonly property color tertiary_fixed: "#bdece0"
        readonly property color tertiary_fixed_dim: "#a1d0c4"

        readonly property color bg: background
        readonly property color bgAlt: surface_container
        readonly property color text: on_surface
        readonly property color subtext: on_surface_variant
        readonly property color accent: primary
        readonly property color accent2: tertiary
        readonly property color selected: primary_container
        readonly property color hovered: on_secondary_fixed_variant 
        readonly property color border: outline_variant
        readonly property color ok: tertiary
        readonly property color warn: secondary
        readonly property color err: error

        readonly property real radius: 12
        readonly property int pad: 10
    }
