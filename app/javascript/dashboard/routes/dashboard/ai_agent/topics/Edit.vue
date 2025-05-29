<script setup>
import { computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { useStore } from 'dashboard/composables/store';
import { useMapGetter } from 'dashboard/composables/store';
import { useAlert } from 'dashboard/composables';
import { useI18n } from 'vue-i18n';
import PageLayout from 'dashboard/components-next/captain/PageLayout.vue';
import EditTopicForm from '../../../../components-next/captain/pageComponents/topic/EditTopicForm.vue';
import TopicPlayground from 'dashboard/components-next/captain/topic/TopicPlayground.vue';

const route = useRoute();
const store = useStore();
const { t } = useI18n();
const topicId = route.params.topicId;
const uiFlags = useMapGetter('captainTopics/getUIFlags');
const isFetching = computed(() => uiFlags.value.fetchingItem);
const topic = computed(() =>
  store.getters['captainTopics/getRecord'](Number(topicId))
);

const isTopicAvailable = computed(() => !!topic.value?.id);

const handleSubmit = async updatedTopic => {
  try {
    await store.dispatch('captainTopics/update', {
      id: topicId,
      ...updatedTopic,
    });
    useAlert(t('CAPTAIN.TOPICS.EDIT.SUCCESS_MESSAGE'));
  } catch (error) {
    const errorMessage =
      error?.message || t('CAPTAIN.TOPICS.EDIT.ERROR_MESSAGE');
    useAlert(errorMessage);
  }
};

onMounted(() => {
  if (!isTopicAvailable.value) {
    store.dispatch('captainTopics/show', topicId);
  }
});
</script>

<template>
  <PageLayout
    :header-title="topic?.name"
    :show-pagination-footer="false"
    :is-fetching="isFetching"
    :show-know-more="false"
    :back-url="{ name: 'captain_topics_index' }"
  >
    <template #body>
      <div v-if="!isTopicAvailable">
        {{ t('CAPTAIN.TOPICS.EDIT.NOT_FOUND') }}
      </div>
      <div v-else class="flex gap-4 h-full">
        <div class="flex-1 lg:overflow-auto pr-4 h-full md:h-auto">
          <EditTopicForm
            :topic="topic"
            mode="edit"
            @submit="handleSubmit"
          />
        </div>
        <div class="w-[400px] hidden lg:block h-full">
          <TopicPlayground :topic-id="Number(topicId)" />
        </div>
      </div>
    </template>
  </PageLayout>
</template>
