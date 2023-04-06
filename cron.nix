{ config, lib, pkgs, ... }:
let
  auto-pull-script =
    let

      target-branch = "main";
      user = "nginx";
      auto-pull-working-dir = "/var/www/shapemaster";
      git = "${pkgs.git}/bin/git";
      git-as-user = "sudo -u ${user} ${git}";

    in
      pkgs.writeScriptBin "auto-pull.sh" ''
          cd "${auto-pull-working-dir}"

          COMMIT_ID_PREV="$(${git} rev-parse HEAD)"

          ${git-as-user} checkout "${target-branch}"
          ${git-as-user} pull

          COMMIT_ID_NEXT="$(${git} rev-parse HEAD)"

          if [ ! "$COMMIT_ID_PREV" = "$COMMIT_ID_NEXT" ]
          then
             echo "[$(${pkgs.coreutils}/bin/date +%s)]: /var/www/shapemaster updated: $COMMIT_ID_PREV -> $COMMIT_ID_NEXT"
          else
             echo "[$(${pkgs.coreutils}/bin/date +%s)]: /var/www/shapemaster is up to dated: $COMMIT_ID_PREV"
          fi

        '';
in
{
  services.cron = {
    enable = true;
    systemCronJobs = [''
      */1 * * * *      root ${auto-pull-script}/bin/auto-pull.sh 2>&1 >> /root/auto-pull.log
    ''];
  };
}
