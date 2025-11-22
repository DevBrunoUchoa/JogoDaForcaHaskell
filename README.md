# JogoDaForcaHaskell
Primeira Parte do Projeto para a Disciplina de Paradigmas Das Linguagens de Programação (2025.2). Jogo da Forca utilizando o paradigma funcional na Linguagem Haskell.

# Descrição geral do sistema
Jogo da Forca é um sistema interativo no terminal que permite ao usuário tentar adivinhar uma palavra secreta letra por letra. O jogo controla tentativas, letras já usadas e o estado atual da palavra. O objetivo é adivinhar a palavra antes que o número de erros atinja o limite.

# Lista de Funcionalidades

ID | Funcionalidade               | Descrição
1  | Validação de Entrada         | Aceita apenas letras; ignora números e símbolos. Converte para maiúscula.
2  | Escolha aleatória de palavra | A palavra secreta é escolhida de uma lista interna.
3  | Contagem de Tentativas       | Define limite de erros. Cada letra errada decrementa.
4  | Exibição da Palavra Parcial  | Mostra os acertos usando “_” nas posições não descobertas.
5  | Registro de Letras Usadas    | Exibe letras já tentadas para evitar repetição.
6  | Detecção de Vitória          | Verifica se todas as letras foram descobertas.
7  | Detecção de Derrota          | O jogo termina quando o número máximo de erros é atingido.
8  | Menu Inicial                 | Permite: jogar, regras, sair.
9  | Tela de Regras               | Explica como funciona o jogo.
10 | Dificuldade                  | Fácil: mais tentativas e menor número de letras. Difícil: menos tentativas e maior número de letras.
11 | Desenho da Forca             | A cada erro, desenhar etapas no console.
