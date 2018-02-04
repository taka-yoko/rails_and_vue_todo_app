<template>
  <div>
    <!-- 新規作成部分 -->
    <div class="row">
      <div class="col s10 m11">
        <input v-model="newTask" class="form-control" placeholder="Add your task!!">
      </div>
      <div class="col s2 m1">
        <div @click="createTask" class="btn-floating waves-effect waves-light red">
          <i class="material-icons">add</i>
        </div>
      </div>
    </div>
    <!-- リスト表示部分 -->
    <div>
      <ul class="collection">
        <li v-for="task in tasks" v-if="!task.is_done" :id="'row_task_' + task.id" class="collection-item">
          <input type="checkbox" @change="doneTask(task.id)" :id="'task_' + task.id" />
          <label :for="'task_' + task.id">{{ task.name }}</label>
        </li>
      </ul>
    </div>
    <!-- 完了済みタスク表示ボタン -->
    <div class="btn" @click="displayFinishedTasks">Display finished tasks</div>
    <!-- 完了済みタスク一覧 -->
    <div id="finished-tasks" :class="{'display_none': hideFinishedTasks}">
      <ul class="collection">
        <li v-for="task in tasks" :id="'row_task_' + task.id" v-if="task.is_done" class="collection-item">
          <input type="checkbox" :id="'task_' + task.id" checked="checked" />
          <label :for="'task_' + task.id" class="line-through">{{ task.name }}</label>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    data: function() {
      return {
        tasks: [],
        newTask: '',
        hideFinishedTasks: true
      }
    },
    mounted: function() {
      this.fetchTasks();
    },
    methods: {
      fetchTasks: function() {
        axios.get('/api/tasks').then((response) => {
          const fetched_tasks = response.data.tasks;
          for(var i = 0; i < fetched_tasks.length; i++) {
            this.tasks.push(fetched_tasks[i]);
          }
        }, (error) => {
          console.log(error);
        });
      },
      displayFinishedTasks: function() {
        this.hideFinishedTasks = !this.hideFinishedTasks;
      },
      createTask: function() {
        if(!this.newTask) return;

        axios.post('api/tasks', { task: { name: this.newTask } }).then((response) => {
          this.tasks.unshift(response.data.task);
          this.newTask = '';
        }, (error) => {
          console.log(error);
        });
      },
      doneTask: function(task_id) {
        axios.put('/api/tasks/' + task_id, { task: {is_done: 1} }).then((response) => {
          console.log(response);
          this.tasks.forEach(function(obj, index, array) {
            if(obj.id == task_id) {
              array[index].is_done = 1;
            }
          })
        }, (error) => {
          console.log(error);
        });
      },

    }
  }
</script>

<style scoped>
  [v-cloak] {
    display: none;
  }
  .display_none {
    display: none;
  }
  .line-through {
    text-decoration: line-through;
  }
</style>

