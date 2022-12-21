# Project Build Documentation

1. Ensure that `cronie` is installed on the deployment and enable the systemd service by executing the following commands.
   ```
   sudo dnf install cronie
   sudo systemctl enable --now crond.service
   ```
2. Ensure that `docker` is installed on the deployment and enable the systemd service by executing the following the instructions available [here](https://docs.docker.com/engine/install/fedora/).
3. Ensure that the current user can access and make use of the Docker features by executing the following command.
   ```
   sudo usermod -aG docker $(whoami)
   ```
   Log out and log back into the session for the changes to take effect.
4. Clone the build configuration repository locally and make it your present working directory by executing the following commands.
   ```
   git clone https://github.com/t0xic0der/oven.git
   cd oven/buildcfg/mdapi/
   ```
5. Edit the configuration files like `Dockerfile`, `runbuild.sh`, `cronunit.sh` to ensure that they have the absolute/relative paths to each other set up correctly.
6. Ensure that the `cronunit.sh` shell script file is executable by running the following command.
   ```
   chmod +x cronunit.sh
   ```
7. Schedule a cronjob to run every after 10 minutes by executing the following command.
   ```
   crontab -e
   ```
   Within the editor, enter the following text and exit out after saving the contents. Ensure that the absolute/relative paths are mentioned correctly.
   ```
   */10 * * * * /home/alcphost/buildcfg/mdapi/cronunit.sh
   ```
8. Ensure that the cronjob is indeed scheduled properly by checking the output after executing the following command.
   ```
   crontab -l
   ```
9. Keep checking the logs created by the build system in the `buildlog/` directory and that by the `cronie` service by executing the following command.
   ```
   journalctl -u crond.service
   ```

