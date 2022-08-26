import os
import subprocess
from typing import List  # noqa: F401

from libqtile import hook

from libqtile.extension.dmenu import DmenuRun
from libqtile.bar import Bar

# import layout objects
from libqtile.layout.columns import Columns
from libqtile.layout.stack import Stack
from libqtile.layout.xmonad import MonadTall
from libqtile.layout.floating import Floating

# import widgets and bar
from libqtile.widget.groupbox import GroupBox
from libqtile.widget.currentlayout import CurrentLayout
from libqtile.widget.window_count import WindowCount
from libqtile.widget.windowname import WindowName
from libqtile.widget.prompt import Prompt
from libqtile.widget.cpu import CPU
from libqtile.widget.memory import Memory
from libqtile.widget.net import Net
from libqtile.widget.systray import Systray
from libqtile.widget.clock import Clock
from libqtile.widget.volume import Volume

from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from unicodes import lower_left_triangle
from colors import nord_fox

mod = "mod4"
terminal = guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html

    # Launch chrome browser
    Key(
        [mod], "w",
        lazy.spawn("google-chrome-stable"),
        desc="Launch Chrome"
    ),
    Key(
        [mod], "d",
        lazy.spawn("virtualbox"),
        desc="Launch VBox"
    ),

    # Sound
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("amixer -q set Master toggle")
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("amixer -q -D pulse sset Master 5%- unmute")
    ),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("amixer -q -D pulse sset Master 5%+ unmute")
    ),


    # Kyebindig for MonadTall
    Key(
        [mod], "i",
        lazy.layout.grow()
    ),
    Key(
        [mod], "m",
        lazy.layout.shrink()
    ),
    Key(
        [mod], "n",
        lazy.layout.nomalize()
    ),
    Key(
        [mod], "o",
        lazy.layout.maximize()
    ),
    Key(
        [mod, "control"], "space",
        lazy.layout.flip()
    ),

    # Switch between windows
    Key(
        [mod], "h",
        lazy.layout.left(),
        desc="Move focus to left"
    ),
    Key(
        [mod], "l",
        lazy.layout.right(),
        desc="Move focus to right"
    ),
    Key(
        [mod], "j",
        lazy.layout.down(),
        desc="Move focus down"
    ),
    Key(
        [mod], "k",
        lazy.layout.up(),
        desc="Move focus up"
    ),
    Key(
        [mod], "space",
        lazy.layout.next(),
        desc="Move window focus to other window"
    ),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h",
        lazy.layout.shuffle_left(),
        desc="Move window to the left"
    ),
    Key(
        [mod, "shift"], "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right"
    ),
    Key(
        [mod, "shift"], "j",
        lazy.layout.shuffle_down(),
        desc="Move window down"
    ),
    Key(
        [mod, "shift"], "k",
        lazy.layout.shuffle_up(),
        desc="Move window up"
    ),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key(
        [mod, "control"], "h",
        lazy.layout.grow_left(),
        desc="Grow window to the left"
    ),
    Key(
        [mod, "control"], "l",
        lazy.layout.grow_right(),
        desc="Grow window to the right"
    ),
    Key(
        [mod, "control"],
        "j", lazy.layout.grow_down(),
        desc="Grow window down"
    ),
    Key(
        [mod, "control"],
        "k", lazy.layout.grow_up(),
        desc="Grow window up"
    ),
    Key(
        [mod], "n",
        lazy.layout.normalize(),
        desc="Reset all window sizes"
    ),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"], "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key(
        [mod], "Return",
        lazy.spawn(terminal),
        desc="Launch terminal"
    ),
    # Toggle between different layouts as defined below
    Key(
        [mod], "Tab",
        lazy.next_layout(),
        desc="Toggle between layouts"
    ),
    Key(
        [mod], "q",
        lazy.window.kill(),
        desc="Kill focused window"
    ),
    Key(
        [mod, "control"], "r",
        lazy.reload_config(),
        desc="Reload the config"
    ),
    Key(
        [mod, "control"], "q",
        lazy.shutdown(),
        desc="Shutdown Qtile"
    ),
    Key(
        [mod], "r",
        lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"
    ),
]

# groups = [Group(i) for i in "123456789"]
groups = [
    Group(
        "1",
        label="一",
        layout="monadtall"
    ),
    Group(
        "2",
        label="二",
        layout="monadtall"
    ),
    Group(
        "3",
        label="三",
        layout="monadtall"
    ),
]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name)
            ),
        ]
    )

layouts = [
    Stack(
        border_normal=nord_fox['black'],
        border_focus=nord_fox['blue'],
        border_width=2,
        num_stacks=1,
        margin=10,
    ),
    MonadTall(
        border_normal=nord_fox['black'],
        border_focus=nord_fox['blue'],
        margin=10,
        border_width=2,
        single_border_width=2,
        single_margin=10,
    ),
    Columns(
        border_normal=nord_fox['black'],
        border_focus=nord_fox['blue'],
        border_width=2,
        border_normal_stack=nord_fox['black'],
        border_focus_stack=nord_fox['blue'],
        border_on_single=2,
        margin=10,
        margin_on_single=10,
    )
]

floating_layout = Floating(
    border_normal=nord_fox['black'],
    border_focus=nord_fox['blue'],
    border_width=2,
    float_rules=[
        *Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="pavucontrol"),
        Match(wm_class="zoom"),
    ]
)

widget_defaults = dict(
    # font="sans",
    font="TerminessTTF Nerd Font",
    fontsize=13,
    padding=10,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=Bar(
            [
               GroupBox(
                    borederwidth=0,
                    active=nord_fox['black'],
                    inactive=nord_fox['fg_gutter'],
                    disable_drag=True,
                    block_highlight_text_color=nord_fox['red'],
                    highlight_color=nord_fox['bg'],
                    highlight_method="line",
               ),
               # right_arrow(nord_fox['orange'], nord_fox['bg']),
               lower_left_triangle(nord_fox['bg'], nord_fox['orange']),
               CurrentLayout(
                    background=nord_fox['orange'],
                    foreground=nord_fox['bg']

               ),
               # right_arrow(nord_fox['yellow'], nord_fox['orange']),
               lower_left_triangle(nord_fox['orange'], nord_fox['magenta']),
               WindowCount(
                    background=nord_fox['magenta'],
                    show_zero=True,
                    foreground=nord_fox['bg']
               ),
               # right_arrow(nord_fox['bg'], nord_fox['yellow']),
               lower_left_triangle(nord_fox['magenta'], nord_fox['bg']),
               Prompt(),
               WindowName(),
               Systray(),
               # left_arrow(nord_fox['bg'], nord_fox['blue']),
               lower_left_triangle(nord_fox['bg'], nord_fox['blue']),
               CPU(
                    format=' {freq_current}GHz {load_percent}%',
                    background=nord_fox['blue'],
                    foreground=nord_fox['black']
               ),
               # left_arrow(nord_fox['blue'], nord_fox['magenta']),
               lower_left_triangle(nord_fox['blue'], nord_fox['pink']),
               Memory(
                    format=' {MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}',
                    background=nord_fox['pink'],
                    foreground=nord_fox['bg']
               ),
               # left_arrow(nord_fox['magenta'], nord_fox['cyan']),
               lower_left_triangle(nord_fox['pink'], nord_fox['green']),
               Net(
                    background=nord_fox['green'],
                    foreground=nord_fox['bg']
               ),
               # left_arrow(nord_fox['cyan'], nord_fox['black']),
               lower_left_triangle(nord_fox['green'], nord_fox['black']),
               Volume(
                    background=nord_fox['black'],
                    emoji=True,
               ),
               # left_arrow(nord_fox['black'], nord_fox['bg']),
               lower_left_triangle(nord_fox['black'], nord_fox['black']),
               Clock(
                    background=nord_fox['black'],
                    foreground=nord_fox['red'],
                    format="%Y-%m-%d %a %I:%M %p"
                ),

            ],
            background=nord_fox['bg'],
            size=24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]
            # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod], "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position()
    ),
    Drag(
        [mod], "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size()
    ),
    Click(
        [mod], "Button2",
        lazy.window.bring_to_front()
    ),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "LG3D"
