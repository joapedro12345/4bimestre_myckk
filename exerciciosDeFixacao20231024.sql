-- 1 --
CREATE TRIGGER novo_cliente AFTER INSERT ON Clientes
	FOR EACH ROW INSERT INTO Auditoria VALUES("Um novo cliente foi adicionado");

-- 2 --
CREATE TRIGGER exclusao_cliente BEFORE DELETE ON Clientes
	FOR EACH ROW INSERT INTO Auditoria VALUES("Houve uma tentativa de exclusão de um cliente");

-- 3 --
DELIMITER //
CREATE TRIGGER att_cliente AFTER UPDATE ON Clientes
	FOR EACH ROW
	BEGIN
		DECLARE nome_anti VARCHAR(255);
		DECLARE nome_nov VARCHAR(255);

		SET nome_anti = OLD.nome;
		SET nome_nov = NEW.nome;

		INSERT INTO Auditoria VALUES(nome_antigo, nome_novo);
	END //
DELIMITER ;

-- 4 --
DELIMITER //
CREATE TRIGGER impedir_insercao BEFORE UPDATE ON Clientes
	FOR EACH ROW
	BEGIN
		DECLARE nome_anti VARCHAR(255);
		DECLARE nome_nov VARCHAR(255);

		SET nome_anti = OLD.nome;
		SET nome_nov = NEW.nome;

		IF novo_nome IS NULL OR novo_nome = '' THEN
			INSERT INTO Auditoria VALUES("Houve uma tentativa de atualizar um nome da tabela Clientes para NULL ou vazio");
			SIGNAL SQLSTATE "45000"
			SET MESSAGE_TEXT = "Não há permissão para atualizar um nome da tabela Clientes para NULL ou vazio";
		END IF;
	END //
DELIMITER ;
