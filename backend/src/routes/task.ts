import { Router } from "express";
import { auth, AuthRequest } from "../middlewares/auth";
import { NewTask, tasks } from "../db/schema";
import { db } from "../db";
import { eq } from "drizzle-orm";

const taskRouter = Router();


taskRouter.post('/',auth,async  (req:AuthRequest,res)=>{
    try {
        req.body = {...req.body,uid:req.user!};
        //create a new task
        const newTask : NewTask = req.body;

        const [task] =  await db.insert(tasks).values(newTask).returning();
        res.status(201).json(task);
    } catch (e) {
        console.log(e);
        res.status(500).json({error:e});
    }
});

taskRouter.get('/',auth,async(req:AuthRequest,res)=>{
    try {
        const allTask = await db.select().from(tasks).where(eq(tasks.uid,req.user!));

        res.json(allTask);
    } catch (e) {
        res.status(500).json({error:e});
    }
});

taskRouter.delete('/',auth,async(req:AuthRequest,res)=>{
    try {
        const {taskId}:{taskId:string} = req.body;

        await db.delete(tasks).where(eq(tasks.id,taskId));

        res.json(true);
    } catch (e) {
        res.status(500).json({error:e});
    }
});

export default taskRouter


