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

-- 5 --
DELIMITER //
CREATE TRIGGER pedido AFTER INSERT ON Pedidos
	FOR EACH ROW
	BEGIN
		DECLARE produto_id INT;
		DECLARE quantidade_pedida INT;
		DECLARE estoque_atual INT;
		
		SET produto_id = NEW.produto_id;
		SET quantidade_pedida = NEW.quantidade;
		
		SELECT estoque INTO estoque_atual FROM Produtos WHERE id = produto_id;

		UPDATE Produtos SET estoque = estoque - quantidade_pedida WHERE id = produto_id;
		
		IF estoque_atual - quantidade_pedida < 5 THEN
			INSERT INTO Auditoria VALUES("Estoque do produto " || produto_id || " está com menos de 5 unidades");
		END IF;
	END //
DELIMITER ;
