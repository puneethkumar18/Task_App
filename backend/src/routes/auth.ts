import{ Router,Request,Response } from "express";
import { db } from "../db";
import { NewUser, users } from "../db/schema";
import { eq } from "drizzle-orm";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import { auth, AuthRequest } from "../middlewares/auth";



const authRouter  = Router();

interface SignUpBody{
    name:string,
    email:string,
    password:string,
}

interface LogInBody{
    email:string;
    password:string,
}


// LOGIN USER
authRouter.post("/logIn", async (req:Request<{},{},LogInBody>,res:Response)=>{
    try {
        // get the data
        const {email,password} = req.body;
        const [existingUser] = await db.select().from(users).where(eq(users.email,email));
        if(!existingUser){
            res.status(400).json({msg:"User with the email id Does'nt exits!"});
            return;
        }
        const isMatch =  await bcryptjs.compare(password,existingUser.password);

        if(!isMatch){
            res.status(400).json({msg:"Incorrect Password!"});
            return ;
        }

        const token = jwt.sign({id:existingUser.id},"passwordKey");

        res.json({token,...existingUser});
        
    } catch (e) {
        res.status(500).json({error:e});
    }
});


// SIGNUP USER
authRouter.post("/signUp", async (req:Request<{},{},SignUpBody>,res:Response)=>{
    try {
        // get the data
        const {name ,email,password} = req.body;
     
        const existingUser = await db.select().from(users).where(eq(users.email,email));
        if(existingUser.length){
            res.status(400).json({msg:"User with the email id already exits!"});
            return;
        }
        // hashed pw
        const hasedPassword = await bcryptjs.hash(password,8);

        //create new user store in db
        const newUser:NewUser = {
            name,
            email,
            password:hasedPassword
        };

        const [user] = await db.insert(users).values(newUser).returning();
        res.status(201).json(user)

    } catch (e) {
        res.status(500).json({error:e});
    }
});

// Check Toekn is Valid

authRouter.post("/isTokenValid",async (req,res)=>{
    try {
        //get the header
        const token = req.header("x-auth-token");
        if(!token) {
            res.json(false);
            return ;
        }
        // verify is token is valid
        const verified = jwt.verify(token,"passwordKey");
        
        if(!verified)  {
            res.json(false);
            return
        }
        
        // get the user data if token is valid
        
        const verifiedToken = verified as {id: string};
        const [user]  = await db.select().from(users).where(eq(users.id,verifiedToken.id));

        if(!user){
            res.json(false);
            return;
        }
        res.json(true);
    } catch (e) {
        res.status(500).json({error:e});
    }
});

authRouter.get("/",auth,async (req:AuthRequest,res)=>{
   try {
    if(!req.user){
        res.status(401).json({msg:"User not found!"});
        return;
    }
    const [user] = await db.select().from(users).where(eq(users.id ,req.user));

    res.json({...user,token:req.token});
   } catch (e) {
    res.status(500).json({error:e});
   }
});

export default authRouter;  