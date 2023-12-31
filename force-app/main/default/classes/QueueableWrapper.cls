/**
 * @author: GLOBANT/ Josue Beltrán Uresti.
 * @date: 04/09/2022.
 * @group:
 * @description: 
 */

public abstract class QueueableWrapper  implements Queueable, Database.AllowsCallouts {
    private static Integer counter = 0;
    public String name;
    public QueueableWrapper(String name) {
        this.name = name + '.' + ++counter + System.now().format();
    }
    abstract void work();

    public void execute(QueueableContext ctx) {
        System.debug(LoggingLevel.DEBUG,'>>> start :' + this.name);
        this.work();
        currentChain.commitQueue();
    }
    public static void enqueueJob(QueueableWrapper queueable) {
        currentChain.add(queueable);
        if (!System.isQueueable()) {
            if (!Test.isRunningTest()) {
                System.enqueueJob(queueable);
            }
        }
    }
    @TestVisible
    private class QueueableChain implements Queueable, Database.AllowsCallouts {
        private List<QueueableWrapper> chain = new List<QueueableWrapper>();
        public void execute(QueueableContext ctx) {
            if (this.chain.isEmpty()) {
                return;
            }
            QueueableWrapper current = this.chain.remove(0);

            if (!this.chain.isEmpty()) {
                for (QueueableWrapper queueable : this.chain) {
                    if (!Test.isRunningTest()) {
                        enqueueJob(queueable);
                    }
                }
            }

            current.execute(ctx);
        }

        public void add(QueueableWrapper queueable) {
            if (queueable == null) {
                return;
            }
            this.chain.add(queueable);
        }

        public void commitQueue() {
            if (this.chain.isEmpty()) {
                return;
            }
            if (!Test.isRunningTest()) {
                System.enqueueJob(this);
            }
        }
    }
    @TestVisible
    private static final QueueableChain currentChain = new QueueableChain();
}