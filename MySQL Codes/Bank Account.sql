-- Explorando os comandos DDL

SELECT now() AS Timestamp;

DROP DATABASE manipulation;
CREATE DATABASE IF NOT EXISTS manipulation;
USE manipulation;

CREATE TABLE bankAccounts(
	Id_account INT auto_increment primary key,
    Ag_num INT NOT NULL,
    Ac_num INT NOT NULL,
    Saldo FLOAT,
    CONSTRAINT Identification_account_constraint UNIQUE (Ag_num, Ac_num)
);

INSERT INTO bankAccounts (Ag_num, Ac_num, Saldo) VALUES (156,265358,0);
SELECT * FROM bankAccounts;

-- Adicionando atributos a bankAccounts com o ALTER
ALTER TABLE bankAccounts ADD LimiteCredito FLOAT NOT NULL default 500.00;

ALTER TABLE bankAccounts ADD email VARCHAR(60);

-- Removendo um atributo com ALTER
ALTER TABLE bankAccounts DROP COLUMN email;

-- ALTER TABLE nome_tabela modify column nome_atributo tipo_dados condicao;
-- ALTER TABLE nome_tabela add constraint nome_constraint condicoes;

DESC bankAccounts;

CREATE TABLE bankClient(
	Id_client INT auto_increment,
    ClientAccount INT,
    CPF CHAR(11) NOT NULL,
    RG CHAR(9) NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Endereço VARCHAR(100) NOT NULL,
    Renda_mensal FLOAT,
    PRIMARY KEY (iD_Client, ClientAccount),
    CONSTRAINT fk_account_client FOREIGN KEY (ClientAccount) REFERENCES bankAccounts(Id_account)
    ON UPDATE CASCADE
);

ALTER TABLE bankClient ADD UFF CHAR(2) NOT NULL DEFAULT 'RJ';

INSERT INTO bankClient (ClientAccount, CPF, RG, Nome, Endereço, Renda_mensal) VALUES (1,12345678913,123456789,'Fulano','rua de lá', 6500.6);
SELECT * FROM bankClient;

-- UPDATE, modificando informações dentro do Schema
UPDATE bankClient SET UFF = 'MG' WHERE Nome = 'Fulano';

DROP TABLE bankClient;

CREATE TABLE bankTransactions(
	Id_transaction INT auto_increment PRIMARY KEY,
    Ocorrencia DATETIME,
    Status_transaction VARCHAR(20),
    Valor_transferencia FLOAT,
    Source_account INT,
    Destination_account INT,
    CONSTRAINT fk_source_transaction FOREIGN KEY (Source_account) REFERENCES
    bankAccounts(id_Account),
    CONSTRAINT fk_destination_transaction FOREIGN KEY (destination_account) REFERENCES
    bankAccounts(id_Account)
);
