
#!/bin/bash
if [ ! -e decodeur.c ]; then
cat << tag > decodeur.c
#include <stdio.h>

    //La fonction "ChercherIndice" permet de déterminer l'indice des caractères encodé grâce à la correspondance
int ChercherIndice(int indice[8]) {
    int i, j;
    char car[8]; //Le tableau "car" est utilisé pour stocker les caractères encodé de l'entreé standard
    char caracteres[32] = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5'}; //La liste des caractères pour la correspondance

    for (i = 0; i < 8; i++) {
        car[i] = getchar();
        if(car[i] == EOF) { //S'il n'y a plus de caractères sur l'entrée standard alors on retourne 1 que l'on va stocker dans etatBourrage
            return 1;
        }
        else { //Sinon on compare le caractère stocker dans "car" avec ceux stocké dans "caractères" pour déterminer son indice
            for(j = 0; j < 32; j++) {
                if(car[i] == caracteres[j]) {
                    indice[i] = j; //Son indice est ensuite stocké
                }
            }   
        }
    }

    return 0; //Une fois fini on retourne 0 que l'on va stocker dans etatBourrage
}

    //La fonction "IndiceEnBinaire" permet de faire la convertion des indices des caractères encodé de l'entrée standard en leur représentation binaire
void IndiceEnBinaire(int indice[8], char entree[8][8]) {
    int i, j, x;
    
    for(i = 0; i < 8; i++) { //On parcourt tout le tableau "indice"
        x = 7;
        for (j = 0; j < 8; j++) {
            entree[i][j] = (indice[i] >> x ) & 1; //On met la représentation binaire de l'indice dans un autre tableau
            x--;
        }
    }
}

    //La fonction "Decodage" permet de décoder les représentation binaire des indices contenu dans le tableau "entree" pour retrouver les représentations binaire des caractères d'origines
void Decodage(char entree[8][8], char sortie[5][8]) {
    int i, j, y;
    int x = 0;
    int compteur = 0; //On initialise un compteur qui va compter le nombre de ligne du premier tableau que l'on a déjà parcouru entièrement

    for(i = 0; i < 8; i++) { //On parcourt le tableau par ligne
        y = i;
        if(i % 2 != 0) { //Si "i" est impair, "x" prend la valeur de "i" car les valeurs d'indice impair du premier tableau seront stocké dans les lignes impair du second
            x = compteur;
        }
        for(j = 3; j < 8; j++) { //On parcourt le tableau par colonne en commençant par la quatrième car les trois premières contiennent des "0"
            if(j == 7 - compteur) { //Ce if sert à stocker les valeurs dans la dernière colonne du second tableau car celle-ci sont situé dans la ligne d'après
                x++; //On incrémente alors "x" de 1 pour prendre les valeurs de la prochaine ligne
                if(i % 2 != 0) { //Si "i" est impair alors "y" sera toujours égal à 1
                    y = 1;
                }
                else { //Sinon si "i" est pair alors "y" sera toujours égal à 0
                    y = 0;
                }
            }
            sortie[x][y] = entree[i][j]; //Le second tableau prend la valeur du premier
            y += 2; //On incrémente "y" de 2 pour toujours avoir des pairs quand "y" commence pair, et pour toujours avoir des impairs quand "y" commence impair
        }
        if(i % 2 != 0) { //Si "i" est impair alors on a parcouru entièrement la première ligne du premier tableau
            compteur++;
        }
    }
}

    //La fonction "RemplirSortie" permet d'afficher sur la sortie standard les caractères de l'entrée standard décodé
void RemplirSortie(char sortie[5][8], char car[5]) {
    int i, j;
    int bourrage = 0; //On initialise une variable "bourrage" pour savoir à partir de quelle ligne est le bourrage

    for(i = 0; i < 5; i++) { //On parcourt le tableau 
        if(sortie[i][0] != 1) { //Si la ligne commence par un 1, c'est que c'est la ligne du début du bourrage
            bourrage++; //Si ce n'est pas le cas, pas de bourrage alors on incremente "bourrage" de 1
        }
    }

    for(i = 0; i < bourrage; i++) { //On parcourt du début du tableau jusqu'à la ligne de bourrage s'il y en a une
        int val = 0;
        int puissance = 1;
        for (j = 7; j >= 0; j--) {
            val += sortie[i][j] * puissance; //On convertie le binaire en décimal
            puissance *= 2;
        }
        car[i] = val;
    }

    for (i = 0; i < bourrage; i++) {
        printf( "%c", car[i]); //On affiche le caractére sur la sortie standard
    }
}


int main(int argc, char *argv[]) {
    int i, j;
    int etatBourrage = 0; //Cette variable permet de savoir si le bourrage a été effectué ou non, et donc de savoir si l'entrée standard est vide ou non
    int indice[8]; //Ce tableau permet de stocker l'indice des caractères venant de l'entrée standard
    char car[5]; //Ce tableau permet de stocker les caractères décodé de l'entrée standard

    char entree[8][8]; //On initialise un premier tableau qui servira à stocker la représentation binaire des caractères de l'entrée standard
    char sortie[5][8]; //On initialise un deuxième tableau qui servira à stocker la représentation binaire des caractères de l'entrée standard décodé
    for(i = 0; i < 8; i++) { //On parcourt le premier tableau pour remplir ses trois premières colonnes de 0
        for(j = 0; j < 3; j++) {
            entree[i][j] = 0;
        }
    }
    
    while(etatBourrage == 0) { //Tant que "etatBourrage" est égal à 0, le bourrage n'est pas effectué et l'entrée standard n'est pas vide
        etatBourrage = ChercherIndice(indice);
        if(etatBourrage == 0) {
            IndiceEnBinaire(indice, entree);
            Decodage(entree, sortie);
            RemplirSortie(sortie, car); 
        }
    }   
} 
tag
    #On compile le programme
gcc -o decode decodeur.c    
    #On supprime le fichier aprés la création de l'éxécutable                        
rm decodeur.c                                        
fi
if [ ! -e encodeur.c ]; then
cat << tag > encodeur.c
#include <stdio.h>

    //La fonction "RemplirEntree" permet de prendre des paquets de 5 caractères venant de l'entrée standard et mettre leur représentation binaire dans un tableau
    //Elle permet dans le même temps de gérer le bourrage
int RemplirEntree(char entree[5][8], char prochain[1]) {
    int i, j, x;
    char bourrage = '@'; //La représentation binaire de l'@ est 1000000 -> se sera la première ligne du bourrage
    char car[5]; //Le tableau "car" est utilisé pour stocker les packets de 5 caractères venant de l'entrée standard à encoder
    
    for(i = 0; i < 5; i++) {
        if(i == 0) {
            car[i] = prochain[0]; //On met le premier caractère du paquet contenu dans "prochain" dans "car"
        }
        else {
            car[i] = getchar();
        }  
        if(car[i] == EOF) { //On vérifie si l'on atteint le dernier caractère de l'entrée standard à encoder, si oui on rentre dans le if pour faire le bourrage
            car[i] = bourrage; //On donne à "car" la valeur de bourrage soit l'@ si c'est la première fois dans le if
            bourrage = '\0'; //On met ensuite le caractère nul dans "bourrage" qui a comme représentation binaire 0000000
            x = 6;
            for (j = 0; j < 8; j++) {
                entree[i][j] = (car[i] >> x ) & 1; //On met la représentation binaire du caractère contenu dans "car" dans le tableau contenant le paquet de caractère
                x--;
            }
        }
        else {
            x = 7;
            for (j = 0; j < 8; j++) {
                entree[i][j] = (car[i] >> x ) & 1; //On met la représentation binaire du caractère contenu dans "car" dans le tableau contenant le paquet de caractère
                x--;
            }
        }
    }

    prochain[0] = getchar(); //On prend le premier caractère du prochain paquet de 5 caractères
    if(prochain[0] == EOF || bourrage != '@') { //S'il n'y a pas de prochain caractère ou que le bourrage à déjà été fait alors on retourne 1 que l'on va stocker dans etatBourrage
        return 1;
    }
    else { //Sinon on retourne 0 que l'on va stocker dans etatBourrage
        return 0;
    }
}

    /*La fonction "Encodage" permet de mettre toutes les valeurs d'un tableau contenu à un indice pair dans les lignes pair d'un second tableau,
      et toutes les valeurs d'un tableau contenu à un indice impair dans les lignes impair d'un second tableau*/
void Encodage(char entree[5][8], char sortie[8][8]) {
    int i, j, y;
    int x = 0;
    int compteur = 0; //On initialise un compteur qui va compter le nombre de ligne du premier tableau que l'on a déjà parcouru entièrement

    for(i = 0; i < 8; i++) { //On parcourt le tableau par ligne
        y = i;
        if(i % 2 != 0) { //Si "i" est impair, "x" prend la valeur de "i" car les valeurs d'indice impair du premier tableau seront stocké dans les lignes impair du second
            x = compteur;
        }
        for(j = 3; j < 8; j++) { //On parcourt le tableau par colonne en commençant par la quatrième car les trois premières contiennent des "0"
            if(j == 7 - compteur) { //Ce if sert à stocker les valeurs dans la dernière colonne du second tableau car celle-ci sont situé dans la ligne d'après
                x++; //On incrémente alors "x" de 1 pour prendre les valeurs de la prochaine ligne
                if(i % 2 != 0) { //Si "i" est impair alors "y" sera toujours égal à 1
                    y = 1;
                }
                else { //Sinon si "i" est pair alors "y" sera toujours égal à 0
                    y = 0;
                }
            }
            sortie[i][j] = entree[x][y]; //Le second tableau prend la valeur du premier
            y += 2; //On incrémente "y" de 2 pour toujours avoir des pairs quand "y" commence pair, et pour toujours avoir des impairs quand "y" commence impair
        }
        if(i % 2 != 0) { //Si "i" est impair alors on a parcouru entièrement la première ligne du premier tableau
            compteur++;
        }
    }
}

    //La fonction "BinaireEnDecimal" permet de prendre une représentation binaire d'un entier et de l'écrire en décimal en utilisant les puissances de 2
void BinaireEnDecimal(char sortie[8][8], int indice[8]) {
    int i, j;

    for(i = 0; i < 8; i++) {
        int val = 0;
        int puissance = 1;
        for (j = 7; j >= 0; j--) {
            val += sortie[i][j] * puissance; //On convertie le binaire en décimal
            puissance *= 2;
        }
        indice[i] = val;
    }
}

    //La fonction "RemplirSortie" permet d'afficher sur la sortie standard le contenu de l'entrée standard qui a été encodé
void RemplirSortie(int indice[8]) {
    int i;
    char caracteres[32] = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5'}; //La liste des caractères pour la correspondance
	
    for(i = 0; i < 8; i++) { //On parcourt le tableau "indice" contenant les représentations décimals de l'encodage fait avec la fonction "Encodage"
        printf("%c", caracteres[indice[i]]); //On fait la correspondance avec le tableau "caractères" et on les affiche sur la sortie standard
    }
}


int main(int argc, char *argv[]) {
    int i, j;
    int etatBourrage = 0; //Cette variable permet de savoir si le bourrage a été effectué ou non, et donc de savoir si l'entrée standard est vide ou non
    int indice[8]; //Ce tableau permettra de stocker les représentations binaire d'entiers en décimal
    char prochain[1]; //On utilisera "prochain" pour savoir en amont le prochain caractère de l'entrée standard

    char entree[5][8]; //On initialise un premier tableau qui servira à stocker la représentation binaire des caractères de l'entrée standard
    char sortie[8][8]; //On initialise un second tableau qui servira à stocker l'encodage de la représentation binaire des caractères de l'entrée standard
    for(i = 0; i < 8; i++) { //On parcourt le second tableau pour remplir ses trois premières colonnes de 0
        for(j = 0; j < 3; j++) {
            sortie[i][j] = 0;
        }
    }

    prochain[0] = getchar(); //Si celui-ci est vide alors on affiche qu'il est vide
    if(prochain[0] == EOF) {
        etatBourrage = 1; //On met l'état du bourrage à 1 pour montrer que l'entrée standard est vide
        printf("Aucun caractère...\n");
    }

    while(etatBourrage == 0) { //Tant que "etatBourrage" est égal à 0, le bourrage n'est pas effectué et l'entrée standard n'est pas vide
        etatBourrage = RemplirEntree(entree, prochain);
        Encodage(entree, sortie);
        BinaireEnDecimal(sortie, indice);
        RemplirSortie(indice);  
    }
}
tag
    #On compile le programme
gcc -o code encodeur.c
    #On supprime le fichier aprés la création de l'éxécutable  
rm encodeur.c 
fi


	# On regarde s'il y a au moins un argument
[ $# -eq 0 ] && echo "pas d'argument" && exit 1

	# Si my-ball.sh n'existe pas alors on met le shebang en première ligne
if [ ! -e my-ball.sh ] ; then
cat << tag1 > my-ball.sh
#!/bin/bash
tag1
fi

	# La boucle va parcourir tous les arguments donnés ainsi que leur l'arborescence s'il y en a une
for i in $* ; do

		# Si i est un fichier on rentre dans le if
	if [ ! -d $i ] ; then

			# On initialise des variables qui vont récupérer les droits d'accès du fichier i et les convertir en octal tout en séparant ceux des user/group/others respecitvement dans User/Group/Others
		User=`ls -l $i | cut -d ' ' -f 1 | cut -d '-' -f 2- | tr '-' '0' | tr 'r' '4' | tr 'w' '2' | tr 'x' '1' | head -c 3 | sed 's/\(.\)/\1 + /g' `
    	Group=`ls -l $i | cut -d ' ' -f 1 | cut -d '-' -f 2- | tr '-' '0' | tr 'r' '4' | tr 'w' '2' | tr 'x' '1' | tail -c 7 | head -c 3 | sed 's/\(.\)/\1 + /g' `
    	Others=`ls -l $i | cut -d ' ' -f 1 | cut -d '-' -f 2- | tr '-' '0' | tr 'r' '4' | tr 'w' '2' | tr 'x' '1' | tail -c 4 | sed 's/\(.\)/\1 + /g' `

	# On encode le contenu du fichier i tout en le mettant dans my-ball.sh, à l'éxecution de my-ball.sh le fichier i sera recréé avec son contenu décodé et similaire à l'original
cat << tag2 >> my-ball.sh
./decode << tag$i > $1
`./code -m $i < $i`
tag$i
tag2

	# On met la commande pour donner les droits d'accès du fichier i dans my-ball.sh, à l'éxecution de my-ball.sh les droits d'accès seront redonnés en octal grâce aux variables définis lignes 20-22
cat << tag4 >> my-ball.sh
chmod `expr $User 0``expr $Group 0``expr $Others 0` $i
tag4

		# Si i est un dossier on rentre dans le else
	else

			# On initialise des variables qui vont récupérer les droits d'accès du dossier i et les convertir en octal tout en séparant ceux des user/group/others respecitvement dans User/Group/Others
		User=`ls -al | grep ' \.$' | cut -d ' ' -f 1 | tr 'd' '-' | cut -d '-' -f 2- | tr '-' '0' | tr 'r' '4' | tr 'w' '2' | tr 'x' '1' | head -c 3 | sed 's/\(.\)/\1 + /g' `
    	Group=`ls -al | grep ' \.$' | cut -d ' ' -f 1 | tr 'd' '-' | cut -d '-' -f 2- | tr '-' '0' | tr 'r' '4' | tr 'w' '2' | tr 'x' '1' | tail -c 7 | head -c 3 | sed 's/\(.\)/\1 + /g' `
    	Others=`ls -al | grep ' \.$' | cut -d ' ' -f 1 | tr 'd' '-' | cut -d '-' -f 2- | tr '-' '0' | tr 'r' '4' | tr 'w' '2' | tr 'x' '1' | tail -c 4 | sed 's/\(.\)/\1 + /g' `

	# On met la commande pour créer le dossier i ainsi que celle pour lui donner ses droits d'accès dans my-ball.sh, à l'éxecution de my-ball.sh le dossier i sera recréé avec ses droits d'accès initiaux grâce aux variables définis lignes 42-44
cat << tag3 >> my-ball.sh
mkdir -p $i
chmod `expr $User 0``expr $Group 0``expr $Others 0` $i
tag3

			# On regarde dans l'arborescence du dossier i
    	for j in $i/* ; do

				# Si le dossier i n'est pas vide alors on entre dedans avec un appel récursif (cela permet de parcourir toute l'arborescence s'il y en a une)
        	if [ -e $j ] ; then
            	$0 $j
        	fi
    	done
	fi
done

	# On donne les droits d'éxecution à my-ball.sh
chmod +x my-ball.sh
    
