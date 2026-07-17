import '../views/quiz_view.dart';

const opcoesDiagnosticos = [
  'Meduloblastoma',
  'Sarcoma de Ewing',
  'Leucemia Linfoblástica Aguda (LLA)',
  'Leucemia Mieloide Aguda (LMA)',
  'Neuroblastoma',
  'Tumor de Wilms',
  'Retinoblastoma',
  'Osteossarcoma',
  'Glioma de Baixo Grau',
  'Glioma de Alto Grau',
  'Ependimoma',
  'Linfoma Hodgkin',
  'Linfoma Não-Hodgkin',
  'Carcinoma de Córtex Adrenal',
  'Tumor Teratoide Rabdoide Atípico (ATRT)',
  'Nenhum',
  'Outro (Especificar)',
  'Desconhecido',
];

const opcoesCausaObito = [
  'Câncer/Tumor Maligno',
  'Síndrome Genética',
  'Malformação Congênita',
  'Doença Cardiovascular',
  'Óbito ao Nascer',
  'Acidente/Trauma',
  'Causa Natural',
  'Outra Doença Crônica',
  'Covid',
  'Edema pulmonar',
  'Cirrose',
  'Infarto',
  'Outra (especificar)',
  'Desconhecido',
];

const perguntasHistoricoFamiliar = <QuizPergunta>[
  QuizPergunta(
    id: '1.1',
    secao: '1. Identificação do probando',
    titulo: 'Iniciais do(a) paciente',
    descricao:
        'Informe apenas as iniciais para preservar a privacidade. Ex.: JFP.',
    tipo: TipoPergunta.texto,
  ),
  QuizPergunta(
    id: '1.2',
    secao: '1. Identificação do probando',
    titulo: 'Código de identificação (ID/RP/MT)',
    descricao:
        'Digite o código completo do protocolo institucional. Ex.: 00XXPMF.',
    tipo: TipoPergunta.texto,
    obrigatoria: true,
  ),
  QuizPergunta(
    id: '1.3',
    secao: '1. Identificação do probando',
    titulo: 'Data de nascimento',
    tipo: TipoPergunta.data,
  ),
  QuizPergunta(
    id: '1.4',
    secao: '1. Identificação do probando',
    titulo: 'Sexo atribuído no nascimento',
    tipo: TipoPergunta.multiplaEscolha,
    opcoes: ['Masculino', 'Feminino', 'Intersexo', 'Não informado'],
  ),
  QuizPergunta(
    id: '1.5',
    secao: '1. Identificação do probando',
    titulo: 'Com qual gênero o(a) paciente se identifica?',
    descricao: 'Preencher para pacientes maiores de 18 anos.',
    tipo: TipoPergunta.multiplaEscolha,
    opcoes: [
      'Feminino',
      'Masculino',
      'Não binário',
      'Transgênero',
      'Não informado'
    ],
  ),
  QuizPergunta(
    id: '1.6',
    secao: '1. Identificação do probando',
    titulo: 'Altura (cm)',
    descricao: 'Informe o valor em centímetros. Ex.: 165.',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '1.7',
    secao: '1. Identificação do probando',
    titulo: 'Peso (kg)',
    descricao: 'Informe o valor em quilogramas. Ex.: 62,5.',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '1.8',
    secao: '1. Identificação do probando',
    titulo: 'Qual grupo racial/etnia descreve o(a) paciente?',
    tipo: TipoPergunta.multiplaEscolha,
    opcoes: [
      'Branca',
      'Preta',
      'Parda',
      'Amarela',
      'Indígena',
      'Não informado'
    ],
  ),
  QuizPergunta(
    id: '1.9',
    secao: '1. Identificação do probando',
    titulo: 'Qual é a ascendência geográfica/cultural do(a) paciente?',
    descricao: 'Ex.: italiana, alemã, africana etc.',
    tipo: TipoPergunta.texto,
  ),
  QuizPergunta(
    id: '1.10',
    secao: '1. Identificação do probando',
    titulo: 'O(a) paciente foi adotado(a)?',
    tipo: TipoPergunta.simNaoDesconhecido,
  ),
  QuizPergunta(
    id: '1.11',
    secao: '1. Identificação do probando',
    titulo: 'Se foi adotado(a), a adoção ocorreu por um familiar?',
    descricao: 'Preencha somente se aplicável.',
    tipo: TipoPergunta.simNaoDesconhecido,
  ),
  QuizPergunta(
    id: '1.12',
    secao: '1. Identificação do probando',
    titulo: 'Se foi adotado(a), quem foi o adotante?',
    descricao: 'Indique o grau de parentesco do adotante, se conhecido.',
    tipo: TipoPergunta.texto,
  ),
  QuizPergunta(
    id: '1.13',
    secao: '1. Identificação do probando',
    titulo: 'Quem é o(a) responsável legal?',
    descricao: 'Preencha caso o(a) paciente seja menor de 18 anos.',
    tipo: TipoPergunta.texto,
  ),
  QuizPergunta(
    id: '1.14',
    secao: '1. Identificação do probando',
    titulo: 'Quantos irmãos ou meio-irmãos o(a) paciente tem?',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '1.15',
    secao: '1. Identificação do probando',
    titulo: 'Quantos primos o(a) paciente tem?',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '2.1.1',
    secao: '2. Histórico reprodutivo e testes genéticos',
    titulo: 'Com que idade ocorreu a primeira menstruação (menarca)?',
    descricao:
        'Idade em anos. Preencher apenas para probandos do sexo feminino.',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '2.1.2',
    secao: '2. Histórico reprodutivo e testes genéticos',
    titulo: 'Há histórico de perdas gestacionais na família?',
    descricao: 'Indique quais familiares tiveram perdas gestacionais.',
    tipo: TipoPergunta.textoLongo,
  ),
  QuizPergunta(
    id: '2.2.1',
    secao: '2. Histórico reprodutivo e testes genéticos',
    titulo: 'O(a) paciente ou alguém da família já fez teste genético?',
    tipo: TipoPergunta.simNaoDesconhecido,
  ),
  QuizPergunta(
    id: '2.2.2',
    secao: '2. Histórico reprodutivo e testes genéticos',
    titulo: 'Qual teste foi realizado, quando e qual foi o resultado?',
    descricao:
        'Ex.: exoma, painel de genes ou cariótipo. Anexe o laudo quando possível.',
    tipo: TipoPergunta.textoLongo,
  ),
  QuizPergunta(
    id: '3.1',
    secao: '3. Histórico pessoal de câncer',
    titulo: 'Existe diagnóstico de câncer no probando?',
    tipo: TipoPergunta.simNao,
  ),
  QuizPergunta(
    id: '3.2',
    secao: '3. Histórico pessoal de câncer',
    titulo: 'Qual é o tipo de câncer primário principal?',
    descricao: 'Preencha somente se houver diagnóstico.',
    tipo: TipoPergunta.multiplaEscolha,
    opcoes: opcoesDiagnosticos,
  ),
  QuizPergunta(
    id: '3.3',
    secao: '3. Histórico pessoal de câncer',
    titulo: 'Qual era a idade exata no momento do diagnóstico?',
    descricao: 'Informe a idade na data da biópsia ou do laudo.',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '3.4',
    secao: '3. Histórico pessoal de câncer',
    titulo: 'Detalhamento dos tumores, caso houver',
    descricao:
        'Para cada tumor, informe tipo, local, idade no diagnóstico e observações.',
    tipo: TipoPergunta.tumores,
  ),
  QuizPergunta(
    id: '4',
    secao: '4. Irmãos e meio-irmãos',
    titulo: 'Detalhe o histórico de irmãos e meio-irmãos',
    descricao:
        'Para cada pessoa, informe parentesco, nome/iniciais, diagnóstico, teste genético, '
        'gênero, nascimento, estado vital, adoção, cônjuge/relação, idade atual ou no '
        'diagnóstico/óbito, causa da morte e observações. Dados aproximados são aceitos.',
    tipo: TipoPergunta.familiares,
    opcoes: [
      'Irmão(ã) (Pleno)',
      'Meio-irmão(ã) (Paterno)',
      'Meio-irmão(ã) (Materno)',
    ],
  ),
  QuizPergunta(
    id: '5.1',
    secao: '5. Linhagem paterna',
    titulo: 'Nome completo do pai',
    tipo: TipoPergunta.texto,
  ),
  QuizPergunta(
    id: '5.2',
    secao: '5. Linhagem paterna',
    titulo: 'Qual é a data de nascimento do pai?',
    descricao: 'Informe no formato DD/MM/AAAA.',
    tipo: TipoPergunta.data,
  ),
  QuizPergunta(
    id: '5.3',
    secao: '5. Linhagem paterna',
    titulo: 'O pai do probando está vivo?',
    tipo: TipoPergunta.multiplaEscolha,
    opcoes: ['Vivo', 'Falecido', 'Desconhecido'],
  ),
  QuizPergunta(
    id: '5.4',
    secao: '5. Linhagem paterna',
    titulo: 'Qual era a idade do pai quando faleceu?',
    descricao: 'Preencha somente se o pai for falecido.',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '5.5',
    secao: '5. Linhagem paterna',
    titulo: 'Qual foi a causa do óbito do pai?',
    tipo: TipoPergunta.multiplaEscolha,
    opcoes: opcoesCausaObito,
  ),
  QuizPergunta(
    id: '5.6',
    secao: '5. Linhagem paterna',
    titulo: 'O pai tem histórico de câncer ou condição médica grave?',
    tipo: TipoPergunta.multiplaEscolha,
    opcoes: opcoesDiagnosticos,
  ),
  QuizPergunta(
    id: '5.7',
    secao: '5. Linhagem paterna',
    titulo: 'Existe relação biológica entre a mãe e o pai do probando?',
    descricao:
        'Indique eventual consanguinidade. Ex.: primos de primeiro grau ou não parentes.',
    tipo: TipoPergunta.texto,
  ),
  QuizPergunta(
    id: '5.8',
    secao: '5. Linhagem paterna',
    titulo: 'Quantos irmãos biológicos o pai tem?',
    descricao: 'Informe o total de tios paternos.',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '5.9',
    secao: '5. Linhagem paterna',
    titulo: 'Quantos sobrinhos o pai tem?',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '5.10',
    secao: '5. Linhagem paterna',
    titulo: 'Algum dos irmãos do pai foi adotado?',
    tipo: TipoPergunta.simNaoDesconhecido,
  ),
  QuizPergunta(
    id: '5.11',
    secao: '5. Linhagem paterna',
    titulo: 'Algum dos sobrinhos do pai foi adotado?',
    tipo: TipoPergunta.simNaoDesconhecido,
  ),
  QuizPergunta(
    id: '5.12',
    secao: '5. Linhagem paterna',
    titulo: 'Há casos de consanguinidade na família paterna?',
    tipo: TipoPergunta.simNaoDesconhecido,
  ),
  QuizPergunta(
    id: '5.13',
    secao: '5. Linhagem paterna',
    titulo: 'Se sim, qual é o casal e o parentesco?',
    descricao: 'Informe os nomes do casal e o grau de parentesco.',
    tipo: TipoPergunta.textoLongo,
  ),
  QuizPergunta(
    id: '6',
    secao: '6. Parentes por parte de pai',
    titulo: 'Detalhe pais, avós, irmãos e tios da linhagem paterna',
    descricao:
        'Para cada pessoa, informe parentesco, nome/iniciais, diagnóstico, teste genético, '
        'gênero, nascimento, estado vital, adoção, cônjuge/relação, idade atual ou no '
        'diagnóstico/óbito, causa da morte e observações. Dados aproximados são aceitos.',
    tipo: TipoPergunta.familiares,
    opcoes: [
      'Pai',
      'Mãe',
      'Padrasto',
      'Madrasta',
      'Avô(ó) Paterno',
      'Avô(ó) Materno',
      'Tio(a) Paterno',
      'Tio(a) Materno',
      'Tio(a) da mãe',
      'Tio(a) do pai',
      'Irmão(ã) (Pleno)',
      'Meio-irmão(ã) (Paterno)',
      'Meio-irmão(ã) (Materno)',
      'Desconhecido',
    ],
  ),
  QuizPergunta(
    id: '7',
    secao: '7. Primos do pai',
    titulo: 'Detalhe os primos do pai',
    descricao:
        'Para cada pessoa, informe os genitores, parentesco, identificação, diagnóstico, '
        'teste genético, gênero, nascimento, idades, estado vital, adoção, relação, '
        'filhos, causa da morte e observações.',
    tipo: TipoPergunta.familiares,
    opcoes: ['Primo(a) Paterno', 'Desconhecido'],
  ),
  QuizPergunta(
    id: '8',
    secao: '8. Sobrinhos do pai',
    titulo: 'Detalhe os sobrinhos do pai (primos do probando)',
    descricao:
        'Para cada pessoa, informe os genitores, parentesco, identificação, diagnóstico, '
        'teste genético, gênero, nascimento, idades, estado vital, adoção, relação, '
        'filhos, causa da morte e observações.',
    tipo: TipoPergunta.familiares,
    opcoes: ['Primo(a) Paterno', 'Desconhecido'],
  ),
  QuizPergunta(
    id: '9.1',
    secao: '9. Linhagem materna',
    titulo: 'Nome completo da mãe',
    tipo: TipoPergunta.texto,
  ),
  QuizPergunta(
    id: '9.2',
    secao: '9. Linhagem materna',
    titulo: 'Qual é a data de nascimento da mãe?',
    descricao: 'Informe no formato DD/MM/AAAA.',
    tipo: TipoPergunta.data,
  ),
  QuizPergunta(
    id: '9.3',
    secao: '9. Linhagem materna',
    titulo: 'A mãe do probando está viva?',
    tipo: TipoPergunta.multiplaEscolha,
    opcoes: ['Viva', 'Falecida', 'Desconhecido'],
  ),
  QuizPergunta(
    id: '9.4',
    secao: '9. Linhagem materna',
    titulo: 'Qual era a idade da mãe quando faleceu?',
    descricao: 'Preencha somente se a mãe for falecida.',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '9.5',
    secao: '9. Linhagem materna',
    titulo: 'Qual foi a causa do óbito da mãe?',
    tipo: TipoPergunta.multiplaEscolha,
    opcoes: opcoesCausaObito,
  ),
  QuizPergunta(
    id: '9.6',
    secao: '9. Linhagem materna',
    titulo: 'Com que idade a mãe teve a primeira menstruação (menarca)?',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '9.7',
    secao: '9. Linhagem materna',
    titulo: 'Com que idade a mãe teve o primeiro filho?',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '9.8',
    secao: '9. Linhagem materna',
    titulo: 'A mãe amamentou?',
    tipo: TipoPergunta.simNaoDesconhecido,
  ),
  QuizPergunta(
    id: '9.9',
    secao: '9. Linhagem materna',
    titulo: 'A mãe tem histórico de câncer ou condição médica grave?',
    tipo: TipoPergunta.multiplaEscolha,
    opcoes: opcoesDiagnosticos,
  ),
  QuizPergunta(
    id: '9.10',
    secao: '9. Linhagem materna',
    titulo: 'Quantas vezes a mãe engravidou?',
    descricao: 'Considere partos, natimortos e abortos.',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '9.11',
    secao: '9. Linhagem materna',
    titulo: 'Quantos irmãos biológicos a mãe tem?',
    descricao: 'Informe o total de tios maternos.',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '9.12',
    secao: '9. Linhagem materna',
    titulo: 'Algum dos tios maternos foi adotado?',
    tipo: TipoPergunta.simNaoDesconhecido,
  ),
  QuizPergunta(
    id: '9.13',
    secao: '9. Linhagem materna',
    titulo: 'Quantos sobrinhos a mãe tem?',
    tipo: TipoPergunta.numero,
  ),
  QuizPergunta(
    id: '9.14',
    secao: '9. Linhagem materna',
    titulo: 'Algum dos sobrinhos da mãe foi adotado?',
    tipo: TipoPergunta.simNaoDesconhecido,
  ),
  QuizPergunta(
    id: '9.15',
    secao: '9. Linhagem materna',
    titulo: 'Há casos de consanguinidade na família materna?',
    tipo: TipoPergunta.simNaoDesconhecido,
  ),
  QuizPergunta(
    id: '9.16',
    secao: '9. Linhagem materna',
    titulo: 'Se sim, qual é o casal e o parentesco?',
    descricao: 'Informe os nomes do casal e o grau de parentesco.',
    tipo: TipoPergunta.textoLongo,
  ),
  QuizPergunta(
    id: '10',
    secao: '10. Parentes por parte de mãe',
    titulo: 'Detalhe pais, avós, irmãos e tios da linhagem materna',
    descricao:
        'Para cada pessoa, informe parentesco, nome/iniciais, diagnóstico, teste genético, '
        'gênero, nascimento, estado vital, adoção, cônjuge/relação, idade atual ou no '
        'diagnóstico/óbito, causa da morte e observações. Dados aproximados são aceitos.',
    tipo: TipoPergunta.familiares,
    opcoes: [
      'Avô(á) Materno',
      'Avô(ó) Paterno',
      'Tio(a) Materno',
      'Tio(a) Paterno',
      'Primo(a) Materno',
      'Primo(a) Paterno',
      'Desconhecido',
    ],
  ),
  QuizPergunta(
    id: '11',
    secao: '11. Primos da mãe',
    titulo: 'Detalhe os primos da mãe',
    descricao:
        'Para cada pessoa, informe os genitores, parentesco, identificação, diagnóstico, '
        'teste genético, gênero, nascimento, idades, estado vital, adoção, relação, '
        'filhos, causa da morte e observações.',
    tipo: TipoPergunta.familiares,
    opcoes: ['Primo(a) Materno', 'Desconhecido'],
  ),
  QuizPergunta(
    id: '12',
    secao: '12. Sobrinhos da mãe',
    titulo: 'Detalhe os sobrinhos da mãe (primos do probando)',
    descricao:
        'Para cada pessoa, informe os genitores, parentesco, identificação, diagnóstico, '
        'teste genético, gênero, nascimento, idades, estado vital, adoção, relação, '
        'filhos, causa da morte e observações.',
    tipo: TipoPergunta.familiares,
    opcoes: ['Primo(a) Materno', 'Desconhecido'],
  ),
  QuizPergunta(
    id: '13.1',
    secao: '13. Impressões da entrevista',
    titulo: 'Nome do(a) entrevistador(a)',
    tipo: TipoPergunta.texto,
    valorInicial: 'Beatriz Antonio de Melo do Nascimento',
  ),
];
