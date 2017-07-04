import hmac
import base64

url = "https://sandbox-authservice.priaid.ch/login"
password = input('Escribe tu contraseña:')
rawHashString = hmac.new(bytes(password, encoding='utf-8'),
                         url.encode('utf-8')).digest()
computedHashString = base64.b64encode(rawHashString).decode()

print(computedHashString)
