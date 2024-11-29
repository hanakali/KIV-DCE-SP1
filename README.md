# KIV-DCE-SP1
KIV/DCE - 1. úloha - LoadBalancer

## Zadání
Implementujte architekturu s konfigurovatelným počtem backendů a jedním load balancerem (např. NGINX). K implementaci použijte nástrojů Terraform, Ansible a Docker, jako cloudovou službu využijte univerzitní instanci OpenNebula. Backend i loadbalancer realizujte v podobě kontejnerů, které bude možno sestavit a publikovat v repozitáři na Github (viz Github Actions).

## Popis funkce
Aplikace je dle zadání rozdělena do dvou částí: loadBalancer a backendy.
- LoadBalancer (NGINX) zajišťuje rozložení požadavků na backendy tak, aby byl systém co nejméně zatížen.
- Počet backendů lze nastavit v proměnné backend-nodes-count. Každý backend je vlastně Flask aplikace v pythonu zobrazující podrobnosti služeb definovaných v systému. Zadavatel zadá název služby a pokud je daná služba nalezena, zobrazí o ní podrobnosti.

## Sestavení a spuštění aplikace
Pro správné sputění aplikace je nutné mít nainstalované nástroje Terraform a Ansible. Dále je potřeba sputit Docker Desctop či podobnou aplikaci, která umožňuje běh kontejnerů.

1. Nejprve si naklonujte repozitář a přejděte do něj
   ```bash
   git clone https://github.com/hanakali/KIV-DCE-SP1.git
   cd KIV-DCE-SP1
   ```
3. Otevřte soubor `terraform.tfvars` v adresáři `terraform` a změňte hodnoty proměnných `one_username` a `one_password` na validní hodnoty pro přístup k univerzitní instanci OpenNebula. V tomtéž souboru můžete pomocí proměnné `backend_nodes_count` nastavit počet backendů.
4. Přesuňte se do adresáře terraform a inicializujte terraform
   ```bash
   cd terraform
   terraform init
   ```
5. Nyní můžete vytvořit infrastrukturu
   ```bash
   terraform apply
   ```
6. Dojde k vytvoření složky dynamic_inventories v hlavním adresáři s aktuálními údaji pro Ansible
7. Přejděte do hlavního adresáře a spusťte ansible-playbook pro spuštění instalace
   ```bash
   cd ..
   ansible-playbook -i dynamic_inventories/cluster ansible/cluster-profile.yml
   ```
8. Nasazená aplikace je dostupná na adrese `http://<ip-adresa-load-balanceru>:80`. Pro zobrazení informací o službách použijte formát `http://<ip-adresa-load-balanceru>:80/find/<služba>` napříkald `http://<ip-adresa-load-balanceru>:80/find/echo`
9. Pro úplné ukončení aplikace zadejte následující příkaz, který zruší všechny vytvořené instance.
   ```bash
   terraform destroy
   ```


