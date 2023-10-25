-- 1 --
CREATE TRIGGER novo_cliente AFTER INSERT ON Clientes
	FOR EACH ROW INSERT INTO Auditoria VALUES("Um novo cliente foi adicionado");

-- 2 --
CREATE TRIGGER exclusao_cliente BEFORE DELETE ON Clientes
	FOR EACH ROW INSERT INTO Auditoria VALUES("Houve uma tentativa de exclusão de um cliente");
