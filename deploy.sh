echo "Start Gigalixir Deploy"
pip3 install gigalixir --user
git remote add gigalixir https://$GIGALIXIR_EMAIL:$GIGALIXIR_API_KEY@git.gigalixir.com/$GIGALIXIR_APP_NAME.git
git push gigalixir master
echo "Finish Gigalixir Deploy"