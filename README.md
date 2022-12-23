# Nginx ECS Cluster behind Application Load Balancer With Terraform
### How To Run 
1. Generate Access Key dan Secret Key. Panduan dapat dilihat [disini](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html)
2. Buat file aws_keys.tfvars yang berisi seperti beriku
    ```
        aws_access_key = "{ACCESS KEY}"
        aws_secret_key = "{SECRET KEY}"
    ```
3. Ketikkan
    ```
    terraform init
    ```

4. Ketikkan
    ```
    terraform apply -var-file="aws_keys.tfvars"
    ```

5. Ketikkan apabila ingin menghapus cluster dan service yang sudah tidak digunakan. 
    ```
    terraform destroy -var-file="aws_keys.tfvars"
    ```