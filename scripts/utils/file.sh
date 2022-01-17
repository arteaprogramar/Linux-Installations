#/bin/bash

createTemp(){
    if [[ -d "temp" ]]; then 
        echo -e "Temp ha sido creado"
    else 
        mkdir "temp"
        echo -e "Temp ha sido creado"
    fi
    
}

movetoTemp(){
    cd "temp"
}

deleteTemp(){
    cd ..
    sleep 2
    rm -rf "temp"
}