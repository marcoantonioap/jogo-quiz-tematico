programa
{
	 
	inclua biblioteca Util --> ut
	inclua biblioteca Arquivos --> arq
	inclua biblioteca Texto --> txt
	inclua biblioteca Tipos --> tp
	
	//variaveis globais
	cadeia  tema_global = "", nick_user = ""
	logico  boll_pergunta_ja_sorteada[40]
	cadeia  matriz_armazena_resp_quiz[40][5]
	inteiro numero_questao = 0

	/*
	* Integrantes do grupo:
	* Izabel Carvalho
	* Marco Antonio Araujo Pereira
	* Vinícius Vianna Arrudas
	*/
	
	funcao inicio()
	{
		cadeia  pergunta[40], resposta[120], funcao_resp_usuario
		inteiro qtdQuestao = 0, n=1, indiceDasPerguntasDoTema = 0
		inteiro sorteado
		cadeia  linha_sorteio	

		para(inteiro i = 0; i < 40; i++){
			boll_pergunta_ja_sorteada[i] = falso
		}

		/*
		* as matrizes pergunta e resposta recebem seus respectivos valores obtidos da função separaQuestoes
		* enquanto a variável qtdQuestao recebe o numero de linhas - ou perguntas - do arquivo
		*/
		qtdQuestao = separaQuestoes(pergunta, resposta)		
		
		escreva("*--------------------------------------------------------*")
		escreva("\n")
          escreva("|                      ", tema_global,":                   |")
          escreva("\n")
          escreva("*--------------------------------------------------------*")				
          
		para(inteiro pos=0; pos < qtdQuestao; pos++) {
			se(pergunta[pos] != "" e resposta[pos] != ""){
				
				faca{
					sorteado = ut.sorteia(0, qtdQuestao - 1)
				}
				enquanto(pergunta[sorteado] == "")
							
				numero_questao += 1
				/*
			 	* 1° Armazenar resposta do usuário 
			 	* 2° Armazenar resposta correta
			 	* 3° Armazenar a pergunta já foi sorteada (true or false)
			 	*/							
				funcao_resp_usuario = perguntaSorteada
				(
					pergunta[sorteado], 
					resposta[sorteado], 
					tp.inteiro_para_cadeia(pos, 10)   
				)							 				
			 	
			 	matriz_armazena_resp_quiz[pos][0]  = pergunta[sorteado]
				matriz_armazena_resp_quiz[pos][1]  = resposta[sorteado]	

			 	cadeia resp_tema_usuario, resp_tema_correto

			 	resp_tema_usuario = txt.extrair_subtexto(funcao_resp_usuario, 0, 1)
			 	resp_tema_correto = txt.extrair_subtexto(funcao_resp_usuario, 2, 3)
		 	
				matriz_armazena_resp_quiz[pos][2]  = resp_tema_usuario
				matriz_armazena_resp_quiz[pos][3]  = resp_tema_correto					
				
			}				
		}


		limpa()
		inteiro total_de_pontos = 0, numero_de_acertos = 0
		numero_questao = numero_questao + 1
		
		cadeia resp_retry_game = ""
		
		para(inteiro i = 0; i < qtdQuestao; i++){			
			se(matriz_armazena_resp_quiz[i][2] != ""){
				numero_questao = numero_questao-1
				escreva
				(
					"\n", 
					numero_questao,
					"-) ESCOLHIDA -> ",matriz_armazena_resp_quiz[i][2], "  CORRETA -> ", matriz_armazena_resp_quiz[i][3]								
				)
					
				escreva("\n") 
				escreva("\n")

				se( matriz_armazena_resp_quiz[i][2] == matriz_armazena_resp_quiz[i][3] ){
					total_de_pontos   += 10
					numero_de_acertos += 1
				}				
			}						
																							
		}
		escreva("Infelizmente o jogo chegou ao fim :c ", nick_user, " espero que tenha gostado ;D")
		escreva("\n","*------------------------------------------------*")
		escreva("\n", "Seus números no jogo: ", "\n")
		escreva("\nPontuação:   "         , total_de_pontos  )
		escreva("\n")
		escreva("N° de acertos: "       , numero_de_acertos)
		escreva("\n*------------------------------------------------*\n")

		
		faca{
			escreva("Deseja jogar novamente ", nick_user, "?")
			escreva("\n[S/N]: ")
			leia(resp_retry_game)
		}
		enquanto(resp_retry_game != "N" e resp_retry_game != "n" e resp_retry_game != "S" e resp_retry_game != "s")

		se(resp_retry_game == "N" ou resp_retry_game == "n"){
			limpa()
			escreva("Ok, muito obrigado por passar esse tempo conosco ", nick_user, "\nVolte Sempre!!!")
		}senao{
			limpa()
			inicio()
		}

		
	}

	funcao cadeia perguntaSorteada(cadeia pergunta_sorteada, cadeia resposta_sorteada, cadeia posicao){
		cadeia resp_user = "", resp_perg_sorteada = ""
		inteiro indice_posicao

		indice_posicao = tp.cadeia_para_inteiro(posicao, 10)

		//tem que ser falso e estar dentro do escopo de indice dos temas
		//ou seja: Gekk 0 a 0, Cinema 20 a 29 etc		
		se(boll_pergunta_ja_sorteada[indice_posicao] != verdadeiro){		
			//pergunta e resposta sorteadas parametrizadas pela função
			escreva("\n", numero_questao,"-) ", pergunta_sorteada)
			escreva("\n", resposta_sorteada)
			escreva("\nR: ") 
			leia(resp_user)

			//extraindo resposta correta da pergunta sorteada
			resp_perg_sorteada = txt.extrair_subtexto(
							resposta_sorteada, 
							2, 
							txt.posicao_texto(")", resposta_sorteada, 0) 
						)
			// Extrai: Pipe + espaço em branco + número da resposta correta						
			resp_perg_sorteada = txt.extrair_subtexto(
							resp_perg_sorteada, 
							txt.posicao_texto("|", resp_perg_sorteada, 0),
							(txt.posicao_texto("|", resp_perg_sorteada, 0) + 3)
						)			
	
			// Extrai: espaço em branco + número da reposta correta
			resp_perg_sorteada = txt.extrair_subtexto(resp_perg_sorteada, txt.numero_caracteres(resp_perg_sorteada)-2, txt.numero_caracteres(resp_perg_sorteada))
			// Extrai: apenas número da reposta correta
			resp_perg_sorteada = txt.extrair_subtexto(resp_perg_sorteada, txt.numero_caracteres(resp_perg_sorteada)-1, txt.numero_caracteres(resp_perg_sorteada))

			boll_pergunta_ja_sorteada[indice_posicao]     = verdadeiro	

			limpa()
		
			escreva("*--------------------------------------------------------*")
			escreva("\n")
	          escreva("                      ", tema_global,":                   ")
	          escreva("\n")
	          escreva("*--------------------------------------------------------*")
					
		}
				
		//retornando resposta do usuário e reposta da pergunta sorteada		
		retorne (resp_user + "|" + resp_perg_sorteada)
	}

	funcao inteiro separaQuestoes(cadeia pg[], cadeia rp[]) {
		inteiro number_tema = 0 
		inteiro refArq, pos = 0, pos_relacionada_ao_tema = 0, tema_existe
		cadeia  nomeArq, linha, tema = ""
			
		faca
		{
			escreva("\nOlá, seja bem-vindo ao FATEC-QUIZ!!!")
			escreva("\nPor favor insira seu nick: ")
			leia(nick_user)

			limpa()
			
			escreva(" *------------------------------------------------------*")
	          escreva("\n |               ESCOLHA O TEMA DO QUIZ:                |")
	          escreva("\n *------------------------------------------------------*")
	          escreva("\n |  1 - Cinema                                          |")
	          escreva("\n |  2 - Geek                                            |")
	          escreva("\n |  3 - Games                                           |")
	          escreva("\n |  4 - Música Pop                                      |")
	          escreva("\n")       
	          escreva(" *------------------------------------------------------*")
	          escreva("\nEscolha um tema, ",nick_user,": ")
	          leia(number_tema)
          }enquanto(number_tema <= 0 ou number_tema >= 6)


		escolha(number_tema){
	         caso 1:
	            tema = "Cinema"
	            pare
	         caso 2:
	            tema = "Geek"
	            pare
	         caso 3:
	            tema = "Games"
	            pare
              caso 4:
                 tema = "Música Pop"
                 pare
	         caso contrario:
	         	  escreva("\nTema inválido")
         	}

         	tema_global = tema

          limpa()         
	
		refArq = arq.abrir_arquivo("./quiz.txt", arq.MODO_LEITURA)
	
		enquanto(nao arq.fim_arquivo(refArq)) {
			
			linha = arq.ler_linha(refArq)		
	
			se(txt.numero_caracteres(linha) != 0) {
	
				inteiro pipe, inicial, tamanho
	
				inicial = 0
				tamanho = txt.numero_caracteres(linha)
				//encontra a primera ocorrência de pipe na linha e da sua posição
				pipe = txt.posicao_texto("|", linha, inicial)
	
				tema_existe = txt.posicao_texto(tema, linha, inicial)
				//caso encontre a posição retorna a mesma porém se não encontrar retorna -1 então precisa ser diferente de -1
				se(tema_existe != -1){
					//extrai pergunta
					pg[pos] = txt.extrair_subtexto(linha,     0,       pipe)
					//extrai resposta
					rp[pos] = txt.extrair_subtexto(linha,  pipe,    tamanho)
					//numero de posições relacionada ao tema ou número de perguntas do tema
					//sempre será 10 pois cada tema tem 10 perguntas				
					pos_relacionada_ao_tema++
				}				
				pos++
				//escreva(pos) -> 40 linhas/posições no caso do arquivo quiz.txt
			}
		}

		arq.fechar_arquivo(refArq)
	
		retorne pos
	}

}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 1352; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */