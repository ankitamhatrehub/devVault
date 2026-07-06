import winston from "winston";

const { combine, timestamp, printf } = winston.format;

export const myFormat = printf(({ level, message, timestamp }) => {
  return `${timestamp} [${level}] : ${message}`;
});

export const logger = winston.createLogger({
  level: "info",
  format: combine(timestamp({ format: "YYYY-MM-DD HH:mm:ss" }), myFormat),
  transports: [new winston.transports.Console()],
});

