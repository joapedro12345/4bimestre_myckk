-- 1.
CREATE TRIGGER novo_cliente AFTER INSERT ON Clientes
	FOR EACH ROW INSERT INTO Auditoria VALUES("Um novo cliente foi adicionado");
