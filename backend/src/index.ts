import express from  "express";
import authRouter from "./routes/auth";
import taskRouter from "./routes/task";



const app = express();

app.use(express.json());
app.use('/task',taskRouter);
app.use('/auth',authRouter);

app.listen(8000,()=>{
    console.log("Server is running at  8000 PORT!");
});