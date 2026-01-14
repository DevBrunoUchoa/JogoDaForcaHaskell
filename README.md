# JogoDaForcaHaskell
Primeira Parte do Projeto para a Disciplina de Paradigmas Das Linguagens de Programação (2025.2). Jogo da Forca utilizando o paradigma funcional na Linguagem Haskell.

## Equipe
* Ana Larissa Costa dos Santos
* João Bruno Tavares Uchoa
* Nathan Amaro Trajano
* Raissa Tainá Pordeus Ferreira
* Teones Alex Lira de Farias Filho

## 🚀 Como Rodar o Projeto

### Pré-requisitos
*   **GHC** (Compilador Haskell) e **Cabal** (Gerenciador de pacotes).
    *   Recomendamos instalar via [GHCup](https://www.haskell.org/ghcup/).

### Passo a Passo

1.  **Clone ou baixe** este repositório.
2.  **Verifique o caminho da pasta**:
    *   ⚠️ **Importante**: Certifique-se de que o projeto está em uma pasta simples, **sem espaços** e **sem acentos** no nome (Ex: `C:\Dev\JogoDaForcaHaskell`). O Windows pode dar erro se estiver em "Área de Trabalho".
3.  **Crie o banco de palavras**:
    *   Certifique-se de que o arquivo `palavras.csv` está na raiz do projeto (mesma pasta do arquivo `.cabal`).
    *   Formato do arquivo: `PALAVRA,DIFICULDADE` (Ex: `HASKELL,FACIL`).
4.  **Instale e Rode**:
    Abra o terminal na pasta do projeto e execute:
    ```bash
    cabal run
    ```
    *O Cabal irá baixar as dependências (como `System.Random`) e compilar o projeto automaticamente.*

---

## Descrição geral do sistema
Jogo da Forca é um sistema interativo no terminal que permite ao usuário tentar adivinhar uma palavra secreta letra por letra. O jogo controla tentativas, letras já usadas e o estado atual da palavra. O objetivo é adivinhar a palavra antes que o número de erros atinja o limite.

## Lista de Funcionalidades

| ID | Funcionalidade | Descrição |
| :--- | :--- | :--- |
| 1 | Validação de Entrada | Aceita apenas letras; ignora números e símbolos. Converte para maiúscula. |
| 2 | Escolha aleatória | A palavra secreta é escolhida aleatoriamente do arquivo `palavras.csv`. |
| 3 | Contagem de Tentativas | Define limite de erros. Cada letra errada decrementa as chances. |
| 4 | Exibição da Palavra | Mostra os acertos e usa “_” nas posições não descobertas. |
| 5 | Letras Usadas | Exibe letras já tentadas para evitar repetição. |
| 6 | Vitória | Verifica se todas as letras foram descobertas. |
| 7 | Derrota | O jogo termina quando o número máximo de erros é atingido. |
| 8 | Menu Inicial | Permite: jogar ou sair. |
| 9 | Dificuldade | **Fácil**: Palavras simples (7 erros). **Difícil**: Palavras complexas (5 erros). |
| 10 | Desenho da Forca | A cada erro, o boneco é desenhado progressivamente no console. |

---

## Estrutura de Arquivos

*   `app\Main.hs`: Ponto de entrada e controle do fluxo do jogo.
*   `app\Logica.hs`: Funções puras de validação e estado do jogo.
*   `app\Arquivo.hs`: Manipulação de leitura do arquivo CSV.
*   `palavras.csv`: Banco de dados das palavras.
