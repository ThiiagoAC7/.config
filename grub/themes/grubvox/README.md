<h1 align="center">
  Gruvbox theme for <a href="https://www.gnu.org/software/grub/">Grub</a>
</h1>

<p align="center">
  <img src="./src/gruvbox-dark-theme/logo.png"/>
</p>


## Usage

1. Clone this repository locally and enter the cloned folder:

    ```shell
    git clone https://github.com/czerwiukk/grubvox.git && cd grubvox
    ```

2. Copy all or selected theme from `src` folder to
`/usr/share/grub/themes/`. E.g. to copy all themes use:

    ```shell
    sudo cp -r src/* /usr/share/grub/themes/
    ```

3. Uncomment and edit following line in `/etc/default/grub` to your selected
   theme:

    ```shell
    GRUB_THEME="/usr/share/grub/themes/gruvbox-<flavor>-theme/theme.txt"
    ```

4. Update grub:

    ```shell
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ```

    For Fedora:

    ```shell
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    ```

## 💝 Thanks to

- [Catppuccin for Grub](https://github.com/catppuccin/grub)
