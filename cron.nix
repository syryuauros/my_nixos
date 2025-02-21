{ config, lib, pkgs, ... }:
let
  auto-scripts =
    let

      target-branch = "main";
      user = "nginx";
      auto-pull-working-dir = "/var/www/shapemaster";
      git = "${pkgs.git}/bin/git";
      git-as-user = "sudo -u ${user} ${git}";
      bastion-ip = "20.20.100.1";
      login-ip = "192.168.1.170";
      ntest-dir = "/home/auros/test/ntest";


    in
      pkgs.writeScriptBin "ntest.sh" ''
          date | tee -a ${ntest-dir}/result.txt
          ssh solma@${bastion-ip} ping ${login-ip} -c 10 | grep -oP 'time=\K[\d\.]+' | awk '{sum+=$1; sumsq+=$1*$1} END {print "Average:", sum/NR, "ms"; print "Standard deviation:", sqrt((sumsq - sum*sum/NR)/NR), "ms"}' | tee -a ${ntest-dir}/result.txt
          ssh solma@${bastion-ip} 'date | tee -a /home/solma/ntest/test.txt'
          ssh solma@${bastion-ip} 'script -q -c "scp /home/solma/ntest/ntest.pdf solma@${login-ip}:/auros/home/solma/ntest/" | tee -a /home/solma/ntest/test.txt'
      '';

# $ cat result.txt | grep -oP 'Average: \K[\d\.]+'
# $ cat test.txt | grep -oP 'KB   \K[\d\.]+'


      # pkgs.writeScriptBin "auto-pull.sh" ''
      #     cd "${auto-pull-working-dir}"

      #     COMMIT_ID_PREV="$(${git} rev-parse HEAD)"

      #     ${git-as-user} checkout "${target-branch}"
      #     ${git-as-user} pull

      #     COMMIT_ID_NEXT="$(${git} rev-parse HEAD)"

      #     if [ ! "$COMMIT_ID_PREV" = "$COMMIT_ID_NEXT" ]
      #     then
      #        echo "[$(${pkgs.coreutils}/bin/date +%s)]: /var/www/shapemaster updated: $COMMIT_ID_PREV -> $COMMIT_ID_NEXT"
      #     else
      #        echo "[$(${pkgs.coreutils}/bin/date +%s)]: /var/www/shapemaster is up to dated: $COMMIT_ID_PREV"
      #     fi

      #   '';

in
{
  services.cron = {
    enable = true;
    systemCronJobs = [''
      */1 * * * *      auros    ${auto-scripts}/bin/ntest.sh
    ''];
  };
}

# {
#   services.cron = {
#     enable = true;
#     systemCronJobs = [''
#       */1 * * * *      root ${auto-scripts}/bin/auto-pull.sh 2>&1 >> /root/auto-pull.log
#     ''];
#   };
# }
