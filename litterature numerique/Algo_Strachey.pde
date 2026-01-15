//PROJET J4 : Algorithme de STRACHEY version recettes de cuisine

// J'ai recupéré les mots clés qu'on retrouve sur les sites de cusine type Marmiton
String[] first = {"Gâteau", "Gratin", "Soupe", "Salade", "Rôti", "Tarte", "Quiche"};
String[] second = {"au chocolat", "de saison", "grand-mère", "maison", "aux légumes", "du Dimanche"};

String[] adjectives = {
  "frais", "fondu", "coupé en dés", "chaud", "froid", "haché", "cuit", 
  "croustillant", "doré", "entier", "gourmand", "léger", "salé", "sucré"
};

String[] nouns = {
  "la farine", "le beurre", "les oeufs", "le lait", "le sucre", 
  "les tomates", "les pommes de terre", "le sel", "le poivre", 
  "la crème", "le fromage", "les oignons", "l'huile", "le persil"
};

String[] adverbs = {
  "doucement", "soigneusement", "rapidement", "bien", "délicatement", 
  "généreusement", "lentement", "progressivement"
};

String[] verbs = {
  "Mélangez", "Ajoutez", "Versez", "Coupez", "Faites cuire", 
  "Saupoudrez", "Epluchez", "Battez", "Incorporez", "Râpez"
};

// Variables
int tempsDernier = 0;
String texteAffiche = "";

void setup() {
  size(800, 600);
  PFont font = createFont("Courier New", 22);
  textFont(font);
  
  texteAffiche = letter(); // On appelle la fonction "letter" comme chez Strachey
  tempsDernier = millis();
}

void draw() {
  background(255); 
  fill(0);
  textAlign(LEFT, TOP);
  textLeading(30);
  
  text(texteAffiche, 50, 50, width - 100, height - 100);
  
  if (millis() - tempsDernier > 8000) {
    texteAffiche = letter();
    tempsDernier = millis(); 
  }
}

//My [Adj] [Noun] [Adv] [Verb] your [Adj] [Noun]-->[Verbe] [Adv] [Nom] [Adj] avec [Nom]
String longer() {
  return choice(verbs) + " "
       + maybe(adverbs) 
       + choice(nouns) + " "
       + maybe(adjectives) 
       + " avec "
       + choice(nouns)
       + ".";
}

// You are my [Adj] [Noun] --> C'est [Adj] et [Adj]
String shorter() {
  return " C'est " + choice(adjectives) + " et " + choice(adjectives) + ".";
}

// Melange de phrases
String body() {
  String text = "";
  boolean shortSentence = false;
  
  for (int i = 0; i < 5; i++) {
    // Algorithme Strachey
    if (random(1) > 0.5) {
      text += longer();
      shortSentence = false;
    } else {
      if (shortSentence) {
        
        text = text.substring(0, text.length() - 1) + "; mais" + shorter();
        shortSentence = false;
      } else {
        text += shorter();
        shortSentence = true;
      }
    }
    text += "\n";
  }
  return text;
}

String letter() {
  return "RECETTE : " + choice(first) + " " + choice(second) + "\n\n"
       + body() + "\n\n"
       + "            Bon Appétit,\n"
       + "            La Cheffe.";
}

String choice(String[] words) {
  return words[int(random(words.length))];
}

String maybe(String[] words) {
  if (random(1) > 0.5) {
    return choice(words) + " ";
  }
  return "";
}