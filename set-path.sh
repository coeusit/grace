if [[ $machine == "MinGw" ]]
then
  setx 
else
  docker exec --user="root" -it coeus_development_api_1 sh devsetup.sh
fi
