FROM python:3.11-slim

RUN pip install --upgrade pip

RUN adduser -D worker
USER worker
WORKDIR /home/worker

COPY --chown=worker:worker requirements.txt requirements.txt
RUN pip install --user -r requirements.txt

ENV PATH="/home/worker/.local/bin:${PATH}"

COPY --chown=worker:worker main.py /home/worker/app/main.py

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]