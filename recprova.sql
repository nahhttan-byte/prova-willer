create table investidores(
 id serial primary key,
 	cpf varchar(11) not null,
	nome varchar(100) unique not null,
	nivel_experiencia int check (nivel_experiencia >=0)
	);
	create table carteiras(
  id serial primary key,
  investidores_id int references investidores(id),
  endereco_wallet varchar (100) unique not null,
  rede_blockchain  varchar(100) not null,
  saldo_usd decimal (12,2) check (saldo_usd > 0),
  status VARCHAR (100) DEFAULT 'ativa' CHECK (status IN ('ativa', 'em analise', 'bloqueada'))
  );
  create table corretoras(
  id serial primary key,
  nome_exchange varchar(100) NOT NULL,
  cnpj varchar (14) unique NOT NULL,
  email_suporte varchar (100) unique not null
);
 create table criptomoedas(
  id serial primary key,
  corretora_id INT references corretoras(id),
  nome_moeda varchar(100) unique not null,
  preco_unitario_usd decimal (12,2) check (preco_unitario_usd > 0), 
  categorias VARCHAR(100) DEFAULT 'Layer1' CHECK (categorias IN ('Layer1', 'DeFi', 'Memecoin', 'Stablecoin'))
  );
   create table transacoes_cripto(
  id serial primary key,
  carteira_id INT references carteiras(id),
  criptomoeda_id boolean references criptomoedas(id),
  quantidade decimal (12,2) check (quantidade > 0), 
  valor_pago decimal (12,2) check (valor_pago > 0),
  data_transacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);
  
  INSERT INTO investidores(nome,cpf,nivel_experiencia) VALUES
('João da Silva', '12345678901',  '2'),
('Maria Oliveira', '23456789012',  '7'),
('Carlos Santos', '34567890123',  '5'),
('Ana Souza', '45678901234',  '3'),
('Pedro Costa', '56789012345',  '1');

INSERT INTO carteiras(endereco_wallet, rede_blockchain,saldo_usd,status) VALUES
('fythkifjifa', 'Ethereum',  '2500.00','ativa'),
('xvcbbnnpoiu', 'Bitcoin',  '50.00','em analise'),
('oriusaihfnm', 'Solana',  '1000.00','ativa'),
('lkngtyuiohv', 'Bitcoin',  '4000.00','em analise'),
('mjhgvcdfghj', 'Solana',  '1095.00','ativa');

INSERT INTO corretoras(nome_exchange, email_suporte,cnpj) VALUES
('Otheloroubacoins', 'Otheloroubacoins@email.com',  '12345678901234'),
('nãoélavagemdedinheiro', 'nãoélavagemdedinheiro@email.com',  '23456789012345'),
('mortcoins', 'mortcoins@email.com',  '34567890123456'),
('bitcomit', 'bitcomit@email.com',  '45678901234567'),
('cristainladrão', 'cristainladrão@email.com',  '56789012345678');

INSERT INTO criptomoedas(nome_moeda, preco_unitario_usd, categorias) VALUES
('Bitcoin', '1000.00',  'Layer1'),
('Ethereum', '2000.00',  'DeFi'),
('Solana', '3000.00',  'Layer1'),
('Dogecoin', '4000.00',  'Memecoin'),
('criscoin', '5000000.00',  'Memecoin');

INSERT INTO transacoes_cripto(quantidade, valor_pago) VALUES
('1.00', '1000.00'),
('2.00', '4000.00'),
('3.00', '9000.00'),
('4.00', '12000.00'),
('1.00', '5000000.00');

	select
	c.endereco_wallet,
	c.rede_blockchain,
	c.saldo_usd,
	i.nome as investidor,
	i.cpf
	from carteiras c 
	join investidores i on c.investidores_id = i.id
	where c.status in ('ativa', 'em analise');

    select 
	co.nome_exchange,
	sum(t.valor_pago) as total_movimentado
	from transacoes_cripto t
	join criptomoedas cr on t.criptomoeda_id = cr.id
	join corretoras co on cr.corretora_id = co.id
    group by co.nome_exchange;

	select 
	c.endereco_wallet,
	cr.nome_moeda,
	t.quantidade,
	t.valor_pago,
	t.data_transacao
	from transacoes_cripto t 
	join carteiras c on t.carteira_id = c id 
	join criptomoedas cr on t.criptomoeda_id = cr.id
	where t.valor_pago . 500.00
	order by t.valor_pago desc;

creat view vw_painel_carteiras as
select
    c.endereco_wallet,
    c.rede_blockchain,
    c.status,
    c.saldo_usd,
    i.nome as investidor,
    i.cpf
from carteiras c
join investidores i
    on c.investidores_id = i.id;
