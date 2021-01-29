const app = require('./server');
const supertest = require("supertest");
const request = supertest(app);

app.get("/url", async (req,res) =>{
res.json({message: "Automate all the things - Amazing!"});
});

it("Gets the endpoint status", async done =>
{
    const res = await request.get("/url");
    expect(res.status).toBe(200);
    done();
    
})
it("Tests the endpoint message === Automate all the things!", async done =>
{
    const res = await request.get("/url");
    expect(res.body.message).toBe("Automate all the things - Amazing!");
    done();
    
})
it("Tests the endpoint timestamp exists and has a value less than the test's current timestamp", async done =>
{
    const res = await request.get("/url");
    expect(res.body.timestamp).toBeLessThanOrEqual(Math.floor(Date.now() / 1000));
    done();
    
}) 
