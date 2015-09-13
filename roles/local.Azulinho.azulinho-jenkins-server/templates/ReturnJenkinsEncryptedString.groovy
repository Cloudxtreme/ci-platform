import hudson.util.Secret

def secret = Secret.fromString(args[0])
println(secret.getEncryptedValue())
